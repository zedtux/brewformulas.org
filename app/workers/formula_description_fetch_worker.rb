require 'nokogiri'

#
# Background job to fetch the software description
#
# @author [guillaumeh]
#
class FormulaDescriptionFetchWorker
  include Sidekiq::Worker

  def perform(homebrew_formula_id)
    formula = Homebrew::Formula.find(homebrew_formula_id)
    return unless formula.homepage

    html = Homepage.new(formula.homepage).fetch
    formula.update_description_from!(html)
  rescue Homepage::NotAccessibleError => error
    Rails.logger.error <<-eos
      Import process wasn't able to save the formula #{formula.name}: #{error}
    eos
  end
end
