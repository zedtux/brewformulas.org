class HomebrewGit
  include Sidekiq::Worker

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

      # Extract the class name
      formula_class_name = formula.scan(/require\s?'formula'\n+class\s(\w+) < Formula$/).flatten.first
      formula_class_name = "Homebrew::#{formula_class_name}"

      # Prepend the class with a namespace
      formula.gsub!(/require\s?'formula'\n+class\s\w+ < Formula$/, "require 'homebrew/fake_formula'\n\nclass #{formula_class_name} < Homebrew::FakeFormula")

      # Eval the formula
      eval formula

      # Now access the formula attributes like a normal Ruby class
      klass = formula_class_name.constantize

      # Look for an existing formula
      if homebrew_formula = Homebrew::Formula.where(name: klass.name.demodulize).first
        [:version, :homepage].each do |column|
          homebrew_formula.send "#{column.to_s}=", klass.try(column)
        end
        homebrew_formula.save!
      else
        Homebrew::Formula.create(
          name: klass.name.demodulize,
          version: klass.try(:version),
          homepage: klass.try(:homepage)
        )
      end
    end
  end
end
