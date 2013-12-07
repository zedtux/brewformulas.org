require "nokogiri"

class FormulaDescriptionFetchWorker
  include Sidekiq::Worker

  def perform(homebrew_formula_id)
    formula = Homebrew::Formula.find(homebrew_formula_id)
    return unless formula.homepage

    # Initiate the Homebrew::HomepageContent class
    # in order to fetch the homepage content of the
    # formula passed as argument.
    homepage = Homepage.new(formula.homepage)

    service_detection = ServiceDetection.new(formula.homepage)
    formula.detected_service = service_detection.detected_service

    # Initialize a new Homebrew::Formula::Description
    # which will be responsible to extract the formula
    # description from the readed homepage content.
    description = Homebrew::Formula::Description.new(formula)
    description.lookup_from(homepage.fetch)

    # In the case a description has been found
    if description.found?
      formula.update_attributes(description: description.text, description_automatic: true)
    end
  rescue Homepage::NotAccessibleError => error
    Rails.logger.error "Import process wasn't able to save the formula #{formula.name}: #{error}"
  end
end
