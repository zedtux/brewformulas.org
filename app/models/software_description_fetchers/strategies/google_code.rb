module SoftwareDescriptionFetchers
  module Strategies
    #
    # Google code strategy to fetch the software description
    #
    # @author [guillaumeh]
    #
    class GoogleCode
      def initialize(html_doc)
        @nokogiri_html = html_doc
      end

      def fetch
        fetch_description
      end

      private

      def fetch_description
        xpath = '//span[@itemprop="description"]/text()'
        description = @nokogiri_html.xpath(xpath).first
        description = description.try(:text)
        description.strip if description
      end
    end
  end
end
