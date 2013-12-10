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
        @nokogiri_html = Nokogiri::HTML(content)
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
        fetcher = case @formula.detected_service
        when :github
          SoftwareDescriptionFetchers::Strategies::Github.new(@nokogiri_html)
        when :google_code
          SoftwareDescriptionFetchers::Strategies::GoogleCode.new(@nokogiri_html)
        when :unknown
          SoftwareDescriptionFetchers::Strategies::Default.new(
            @nokogiri_html,
            name: @formula.name,
            filename: @formula.filename
          )
        end
        @description_text = fetcher.fetch
      end

    end
  end
end
