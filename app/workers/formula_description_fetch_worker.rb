require "nokogiri"

class FormulaDescriptionFetchWorker
  include Sidekiq::Worker

  def perform(homebrew_formula_id)
    formula = Homebrew::Formula.find(homebrew_formula_id)
    return unless formula.homepage

    # Initiate the Homebrew::HomepageContent class
    # in order to fetch the homepage content of the
    # formula passed as argument.
    homepage = Homebrew::HomepageContent.new(formula)

    doc = Nokogiri::HTML(homepage.fetch)
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

    # Read from HTML meta description
    unless formula.description?
      if meta_description = doc.xpath("/html/head/meta[@name='description']/@content").first.try(:value)
        formula.update_attributes(description: meta_description, description_automatic: true)
      end
    end

  rescue OpenURI::HTTPError => error
    Rails.logger.error "Import process wasn't able to save the formula #{formula.name}: #{error}"
  end
end
