module Homebrew
  class Formula
    class Description

      #
      # Intanciate a new Homebrew::Formula::Description
      # @param  formula [Homebrew::Formula] Formula for which the description has to be extracted
      #
      # @return [Homebrew::Formula::Description] Returns a new instance of Homebrew::Formula::Description
      def initialize(formula)
        @formula = formula
        @description_text = nil
      end

      #
      # Look up for a description in the given string
      # @param  content [String] String containing somewhere the description
      #
      def lookup_from(content)
        @doc = Nokogiri::HTML(content)
        self.send(:grab_description)
      end

      #
      # Determine if a description has been found
      #
      # @return [Boolean] true if a description has been found otherwise false
      def found?
        @description_text.present?
      end

      #
      # Get the extracted description text
      #
      # @return [String] Extracted description
      def text
        @description_text
      end

    private

      def grab_description
        case @formula.detected_service
        when :github
          self.send(:fetch_github_description)
        when :unknown
          self.send(:look_html_body)
          self.send(:look_html_head) unless self.found?
        end
      end

      def look_html_body
        @doc.traverse do |element|
          next unless ["p", "div", "dd"].include?(element.name)

          clean_text = element.text
          clean_text = clean_text.gsub(/(\n|\t|\s+)/, " ")
          clean_text = clean_text.strip

          if description = clean_text.scan(/(^.*(?:#{@formula.name}|#{@formula.filename})(?:\)|\s\u2122|\s[\d\.]+)?\s(?:is\s(?:an?|the)|(?:project\s)?provides)[\s\w\'\(\)\,\-\+\/\.]+\.(?:\s|$))/i).flatten.first
            @description_text = description.strip
            break
          end
        end
      end

      def look_html_head
        # Read from HTML meta description
        if meta_description = @doc.xpath("/html/head/meta[@name='description']/@content").first.try(:value)
          @description_text = meta_description
        end
      end

      def fetch_github_description
        repository_description = @doc.xpath("//div[contains(@class, 'repository-description')]/p/text()").first
        @description_text = repository_description.try(:text)
      end

    end
  end
end
