class HomebrewFormulaImportWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily }

  #
  # Create new Homebrew::Formula if missing otherwise update the existing one
  # @param  path [String] path to the formula ruby file
  #
  def create_or_update_formula_from(path)

    # Read the Ruby file content
    formula = File.read(path)

    # Extract the formula class name
    # In the case the formula declare more than one Formula class
    # use the latest one as the other are dependencies
    formula_name = formula.scan(/^class\s(\w+)\s<\s(Formula|ScriptFileFormula|AmazonWebServicesFormula|GithubGistFormula)$/).flatten.last

    # Regular expression to extract attributes from the formula ruby code
    regex = /^\s+(homepage|version)\s+(?:'|")(.*)(?:'|")$/

    # Extract the formula attributes shown on brewformulas.org
    extracted_attributes = formula.scan(regex)
    formula_attributes = Hash[*extracted_attributes.flatten]

    # Get filename without extension
    formula_filename = File.basename(path, ".rb")

    # Find or create the formula
    homebrew_formula = Homebrew::Formula.where(filename: formula_filename).first
    homebrew_formula = Homebrew::Formula.new(filename: formula_filename) unless homebrew_formula

    # Set or update the display name
    homebrew_formula.name = formula_name

    formula_attributes.each_pair do |attribute, value|
      homebrew_formula.send "#{attribute.to_s}=", value
    end

    # Touch the formula in order to keep showing it on the homepage
    homebrew_formula.touch

    unless homebrew_formula.save
      Rails.logger.error "Import process wasn't able to save the formula #{formula_filename}: #{homebrew_formula.errors.full_messages.to_sentence}"
    end
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

end
