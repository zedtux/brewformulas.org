class HomebrewFormulaImportWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily }

  #
  # Load the formula Ruby code in order to access attributes
  # @param  formula [String] formula ruby code
  # @param  klasses_to_override=[] [Array] List of class name which have to be overrided
  #   in order to allow the worker to load the ruby code without exceptions.
  #
  def load_formula(formula, klasses_to_override=[])
    eval formula
  rescue NameError => error
    if klass = error.message.scan(/uninitialized constant ([\w\:]+)/).flatten.first
      # For all classes which aren't existing
      # juste override them with the DummyClass
      eval "::#{klass.demodulize} = DummyClass"
      self.load_formula(formula, klasses_to_override)
    else
      raise
    end
  end

  def open_git_repository
    Git.open(
      File.join(
        AppConfig.homebrew.git_repository.location,
        AppConfig.homebrew.git_repository.name
      )
    )
  end

  def clone_git_repository
    Git.clone(
      AppConfig.homebrew.git_repository.url,
      AppConfig.homebrew.git_repository.name,
      path: AppConfig.homebrew.git_repository.location,
      depth: 1 # Without the history
    )
  end

  #
  # Get the Homebrew formulas from Github.com
  #
  # In the case of the source code folder is missing
  # this method will clone the repository (without the history)
  # otherwise just call `git pull`.
  #
  def get_up_to_date_git_repository
    git = if File.exists?(AppConfig.homebrew.git_repository.location)
      self.open_git_repository
    else
      # Create the location path
      FileUtils.mkdir_p(AppConfig.homebrew.git_repository.location)
      # Clone the Git repo to the location path
      self.clone_git_repository
    end

    # Update the code to the HEAD version
    git.pull
  end

  #
  # Create new Homebrew::Formula if missing otherwise update the existing one
  # @param  path [String] path to the formula ruby file
  #
  def create_or_update_formula_from(path)
    # Read the Ruby file content
    formula = File.read(path)

    regex = /require\s?(?:'|")formula(?:'|")[\s\w\W]+^class (\w+) < (Formula|AmazonWebServicesFormula|GithubGistFormula|ScriptFileFormula)$/

    # Extract the class name
    formula_class_name = formula.scan(regex).flatten[0]
    formula_class_name = "Homebrew::#{formula_class_name}"

    # Prepend the class with a namespace
    formula.gsub!(regex, "require 'homebrew/fake_formula'\n\nclass #{formula_class_name} < Homebrew::FakeFormula")

    # Eval the formula
    self.load_formula(formula)

    # Now access the formula attributes like a normal Ruby class
    klass = formula_class_name.constantize

    # Get filename without extension
    formula_filename = File.basename(path, ".rb")

    # Look for an existing formula
    homebrew_formula = Homebrew::Formula.where(filename: formula_filename).first
    homebrew_formula = Homebrew::Formula.new(filename: formula_filename) unless homebrew_formula

    # Save the display name
    homebrew_formula.name = klass.name.demodulize
    homebrew_formula.description =~ /(^.*BIND\s(?:is an?|are).*\.$)/i

    [:version, :homepage].each do |column|
      value = klass.try(column)
      value = value.keys.first if value.is_a?(Hash)
      homebrew_formula.send "#{column.to_s}=", value
    end

    homebrew_formula.touch
    homebrew_formula.save!
  end

  #
  # Get the Homebrew source code from Github
  # and create/update the Homebrew::Formula
  #
  def perform
    self.get_up_to_date_git_repository

    # Build the formulas folder path
    formulas_path = File.join(
      AppConfig.homebrew.git_repository.location,
      AppConfig.homebrew.git_repository.name,
      "Library", "Formula", "*.rb"
    )

    # Treat each files (Ruby files)
    Dir[formulas_path].each{|formula_path| self.create_or_update_formula_from(formula_path)}
  end
end
