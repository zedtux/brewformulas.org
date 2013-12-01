class HomebrewFormulaImportWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  attr_accessor :formula

  recurrence { daily }

  #
  # Create new Homebrew::Formula if missing otherwise update the existing one
  # @param  path [String] path to the formula ruby file
  #
  def create_or_update_formula_from(path)

    # Read the Ruby file content
    self.formula = File.read(path)

    # Get filename without extension
    formula_filename = File.basename(path, ".rb")

    self.send(:create_or_update_formula!, formula_filename)
  end

  #
  # Get the Homebrew source code from Github
  # and create/update the Homebrew::Formula
  #
  def perform
    self.send(:get_up_to_date_git_repository)

    # Build the formulas folder path
    formulas_path = File.join(
      AppConfig.homebrew.git_repository.location,
      AppConfig.homebrew.git_repository.name,
      "Library", "Formula", "*.rb"
    )

    # Treat each files (Ruby files)
    formulas = Dir[formulas_path]
    formulas.each{|formula_path| self.create_or_update_formula_from(formula_path)}

    Rails.logger.info "Iterated over #{formulas.size} formulas and #{Homebrew::Formula.count} in database."
  end

private

  #
  # Get the Homebrew formulas from Github.com
  #
  # In the case of the source code folder is missing
  # this method will clone the repository (without the history)
  # otherwise just call `git pull`.
  #
  def get_up_to_date_git_repository
    git = if File.exists?(AppConfig.homebrew.git_repository.location)
      self.send(:open_git_repository)
    else
      # Create the location path
      FileUtils.mkdir_p(AppConfig.homebrew.git_repository.location)
      # Clone the Git repo to the location path
      self.send(:clone_git_repository)
    end

    # Update the code to the HEAD version
    git.pull
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

  # Find or create the formula
  def find_or_create_formula!(filename, name)
    formula = Homebrew::Formula.find_by(filename: filename)
    formula ? formula : Homebrew::Formula.create(filename: filename, name: name)
  end

  # Extract the formula class name
  # In the case the formula declare more than one Formula class
  # use the latest one as the other are dependencies
  def extract_class_name
    inheriting_classes = ["Formula", "ScriptFileFormula", "AmazonWebServicesFormula", "GithubGistFormula"]
    self.formula.scan(/^class\s(\w+)\s<\s(?:#{inheriting_classes.join("|")})$/).flatten.last
  end

  def extract_formula_attributes
    attributes_to_extract = ["homepage", "version"]
    # Extract the formula attributes shown on brewformulas.org
    extracted_attributes = self.formula.scan(/^\s+(#{attributes_to_extract.join("|")})\s+(?:'|")(.*)(?:'|")$/)
    Hash[*extracted_attributes.flatten]
  end

  def get_dependencies
    dependency_names = self.formula.scan(/^\s+depends_on\s(?:\'|\:)([\w\+\-]+).*$$/).flatten
    dependency_names.collect{|name| self.send(:find_or_create_formula!, name, name.classify)}
  end

  def create_or_update_formula!(formula_filename)
    homebrew_formula = self.send(:find_or_create_formula!, formula_filename, self.send(:extract_class_name))

    homebrew_formula.attributes = self.send(:extract_formula_attributes)
    homebrew_formula.dependencies |= self.send(:get_dependencies)

    # Touch the formula in order to keep showing it on the homepage
    homebrew_formula.touch

    Rails.logger.debug "[debug(#{__FILE__.split("app/")[1]}:#{__LINE__})] homebrew_formula: #{homebrew_formula.inspect}"

    unless homebrew_formula.save
      Rails.logger.error "Import process wasn't able to save the formula #{formula_filename}: #{homebrew_formula.errors.full_messages.to_sentence}"
    end
  end
end
