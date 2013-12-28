#
# Homebrew formulas import job
#
# @author [guillaumeh]
#
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
    formula_filename = File.basename(path, '.rb')

    create_or_update_formula!(formula_filename)
  end

  # Build the formulas folder path
  def formulas_path
    File.join(
      AppConfig.homebrew.git_repository.location,
      AppConfig.homebrew.git_repository.name,
      'Library', 'Formula', '*.rb'
    )
  end

  def import_formulas
    Homebrew::GitRepository.fetch_up_to_date_git_repository

    # Treat each files (Ruby files)
    formulas = Dir[formulas_path]
    formulas.each { |path| create_or_update_formula_from(path) }

    Rails.logger.info <<-eos
      Iterated over #{formulas.size} formulas and #{Homebrew::Formula.count}
      in database including #{Homebrew::Formula.externals.count}
      external formulas.
    eos
  end

  #
  # Get the Homebrew source code from Github
  # and create/update the Homebrew::Formula
  #
  def perform
    @import = Import.create(success: true)

    import_formulas
  rescue StandardError => error
    @import.message = error.message
    @import.success = false
    raise
  ensure
    @import.ended_at = Time.now
    @import.save
  end

  private

  def find_formula_from_filename_or_classname(filename)
    Homebrew::Tools.find_or_create_formula!(
      filename,
      Homebrew::Tools.extract_class_name(formula)
    )
  end

  def create_or_update_formula!(filename)
    homebrew_formula = find_formula_from_filename_or_classname(filename)

    homebrew_formula.attributes = Homebrew::Tools.extract_attributes(formula)
    homebrew_formula.dependencies |= Homebrew::Tools.get_dependencies(formula)
    homebrew_formula.conflicts |= Homebrew::Tools.get_conflicts(formula)

    # Update the external field to false as a file has been found
    # which means that Homebrew provide it and can install it.
    homebrew_formula.external = false

    homebrew_formula.touch

    @import.success = homebrew_formula.save
  end
end
