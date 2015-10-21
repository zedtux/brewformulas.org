module SoftwareDescriptionFetchers
  module Strategies
    #
    # Default strategy when the homepage is not known
    #
    # @author [guillaumeh]
    #
    class Default
      def initialize(nokogiri_html, options = {})
        if options[:name].blank? || options[:filename].blank?
          fail ArgumentError, 'You must provide a name and a filename'
        end

        @software_name = options[:name]
        @software_filename = options[:filename]
        @html = nokogiri_html
      end

      def fetch
        description = look_html_body
        description ? description : look_html_head
      end

      private

      def clean_text(text)
        clean_text = text.gsub(/(\n|\t|\s+)/, ' ')
        clean_text = clean_text.strip
        clean_text
      end

      def regex
        %r{(^.*(?:#{@software_name}|#{@software_filename})
          (?:\)|\s\u2122|\s[\d\.]+|\scodec)?\s(?:is\s
          (?:an?|the)|(?:project\s)?provides)[\s\w\'\(\)\,\-\+\/\.\:]+\.(?:\s|$)
        )}ix
      end

      def look_html_body
        @html.traverse do |element|
          next unless %w(p div dd td li).include?(element.name)

          clean_text = clean_text(element.text)
          description = clean_text.scan(regex).flatten.first
          # Stop and return the description
          return description.strip.gsub(/\s+/, ' ') if description
        end
      end

      def look_html_head
        xpath = '/html/head/meta[@name="description"]/@content'
        @html.xpath(xpath).first.try(:value)
      end
    end
  end
end
