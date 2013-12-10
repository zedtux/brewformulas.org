module SoftwareDescriptionFetchers
  module Strategies
    class Default

      def initialize(nokogiri_html, options={})
        raise ArgumentError, "You must provide a name and a filename" if options[:name].blank? || options[:filename].blank?

        @software_name = options[:name]
        @software_filename = options[:filename]

        @nokogiri_html = nokogiri_html
      end

      def fetch
        description = self.send(:look_html_body)
        description ? description : self.send(:look_html_head)
      end

    private

      def look_html_body
        @nokogiri_html.traverse do |element|
          next unless ["p", "div", "dd", "td"].include?(element.name)

          clean_text = element.text
          clean_text = clean_text.gsub(/(\n|\t|\s+)/, " ")
          clean_text = clean_text.strip

          if description = clean_text.scan(/(^.*(?:#{@software_name}|#{@software_filename})(?:\)|\s\u2122|\s[\d\.]+)?\s(?:is\s(?:an?|the)|(?:project\s)?provides)[\s\w\'\(\)\,\-\+\/\.]+\.(?:\s|$))/i).flatten.first
            # Stop and return the description
            return description.strip.gsub(/\s+/, " ")
          end
        end
      end

      def look_html_head
        @nokogiri_html.xpath("/html/head/meta[@name='description']/@content").first.try(:value)
      end

    end
  end
end
