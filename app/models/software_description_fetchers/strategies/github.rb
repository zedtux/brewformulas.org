module SoftwareDescriptionFetchers
  module Strategies
    class Github

      def initialize(html_doc)
        @doc = html_doc
      end

      def fetch
        self.send(:fetch_description)
      end

    private

      def fetch_description
        @doc.xpath("//div[contains(@class, 'repository-description')]/p/text()").first.try(:text)
      end

    end
  end
end
