require "open-uri"
require "open_uri_redirections"
require "nokogiri"

class FormulaDescriptionFetchWorker
  include Sidekiq::Worker

  def perform(homebrew_formula_id)
    formula = Homebrew::Formula.find(homebrew_formula_id)

    # Load homepage HTML code
    page_content = open(formula.homepage, allow_redirections: :safe).read
    page_content.gsub!(/&shy;/, "") # Remove all Hyphen
    page_content = page_content.encode(
      "UTF-8",
      invalid: :replace,
      undef: :replace,
      replace: "?"
    ) # Manage non UTF-8 characters

    doc = Nokogiri::HTML(page_content)
    doc.traverse do |element|
      next unless ["p", "div", "dd"].include?(element.name)

      clean_text = element.text
      clean_text = clean_text.gsub(/(\n|\t|\s+)/, " ")
      clean_text = clean_text.strip

      if description = clean_text.scan(/(^.*#{formula.name}(\)|\s\u2122|\s[\d\.]+)?\s(is\s(an?|the)|(project\s)?provides)[\s\w\'\(\)\,\-\+\/]+\.)/i).flatten.first
        formula.update_attributes(description: description, description_automatic: true)
        break
      end
    end
  rescue OpenURI::HTTPError => error
    Rails.logger.error "Import process wasn't able to save the formula #{formula.name}: #{error}"
  end
end
