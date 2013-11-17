class HomebrewGit
  include Sidekiq::Worker

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

  #
  # Get the Homebrew source code from Github
  # and keep it up-to-date.
  #
  # Clone the repository the first time, then use `git pull`
  #
  def perform
    git = if File.exists?(AppConfig.homebrew.git_repository.location)
      Git.open(
        File.join(
          AppConfig.homebrew.git_repository.location,
          AppConfig.homebrew.git_repository.name
        )
      )
    else
      # Create the location path
      FileUtils.mkdir_p(AppConfig.homebrew.git_repository.location)
      # Clone the Git repo to the location path
      Git.clone(
        AppConfig.homebrew.git_repository.url,
        AppConfig.homebrew.git_repository.name,
        path: AppConfig.homebrew.git_repository.location,
        depth: 1 # Without the history
      )
    end

    # Update the code to the HEAD version
    git.pull

    # Build the formulas folder path
    formulas_path = File.join(
      AppConfig.homebrew.git_repository.location,
      AppConfig.homebrew.git_repository.name,
      "Library", "Formula", "*.rb"
    )

    # Treat each files (Ruby files)
    Dir[formulas_path].each do |formula_path|
      # Read the Ruby file content
      formula = File.read(formula_path)

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

      # Look for an existing formula
      homebrew_formula = Homebrew::Formula.where(name: klass.name.demodulize).first
      homebrew_formula = Homebrew::Formula.create!(name: klass.name.demodulize) unless homebrew_formula

      [:version, :homepage].each do |column|
        value = klass.try(column)
        value = value.keys.first if value.is_a?(Hash)
        homebrew_formula.send "#{column.to_s}=", value
      end
      homebrew_formula.save!
    end
  end
end
