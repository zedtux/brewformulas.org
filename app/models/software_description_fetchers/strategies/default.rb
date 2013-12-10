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

      def clean_text(text)
        clean_text = text.gsub(/(\n|\t|\s+)/, " ")
        clean_text = clean_text.strip
        clean_text
      end

      def regex
        %r{
          (                                             # Capture the entire line
            ^.*                                         # Can begining with anything
            (?:#{@software_name}|#{@software_filename}) # Then search the software name or filename
            (?:\)|\s\u2122|\s[\d\.]+|\scodec)?          # Following a close parenthese, a TM symbol, a version number, or the codec word
            \s
            (?:
              is\s(?:an?|the)|                          # Following a is a, is an, or is the
              (?:project\s)?provides                    # Or project provides, or just provide
            )
            [\s\w\'\(\)\,\-\+\/\.]+                     # All allowed characters in the description sentence
            \.                                          # And then a dot to end the sentence
            (?:\s|$)                                    # Finally it must ends with a space or end of line
          )
        }ix
      end

      def look_html_body
        @nokogiri_html.traverse do |element|
          next unless ["p", "div", "dd", "td", "li"].include?(element.name)

          clean_text = self.send(:clean_text, element.text)

          if description = clean_text.scan(self.send(:regex)).flatten.first
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
