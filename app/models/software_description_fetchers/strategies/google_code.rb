module SoftwareDescriptionFetchers
  module Strategies
    class GoogleCode

      def initialize(html_doc)
        @nokogiri_html = html_doc
      end

      def fetch
        self.send(:fetch_description)
      end

    private

      def fetch_description
        description = @nokogiri_html.xpath("//td[contains(@class, 'psdescription')]/p/text()").first
        description = description.try(:text)
        description.strip if description
      end

    end
  end
end
