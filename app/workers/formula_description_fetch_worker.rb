require "open-uri"
require "nokogiri"

class FormulaDescriptionFetchWorker
  include Sidekiq::Worker

  def perform(homebrew_formula_id)
    formula = Homebrew::Formula.find(homebrew_formula_id)

    page_content = open(formula.homepage).read

    doc = Nokogiri::HTML(page_content)
    doc.traverse do |element|
      next unless ["p", "div", "dd"].include?(element.name)

      clean_text = element.text
      clean_text = clean_text.gsub(/(\n|\t|\s+)/, " ")
      clean_text = clean_text.strip

      if description = clean_text.scan(/(^.*#{formula.name}(\)|\s\u2122|\s[\d\.]+)?\s(is\s(an?|the)|project\sprovides)[\s\w\'\(\)\,\-\+\/]+\.)/i).flatten.first
        formula.update_attributes(description: description, description_automatic: true)
        break
      end
    end
  rescue OpenURI::HTTPError => error
    Rails.logger.error "Import process wasn't able to save the formula #{formula.name}: #{error}"
  end
end
