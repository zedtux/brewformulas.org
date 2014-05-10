module Homebrew
  class Formula
    #
    # Extract the Homebrew::Formula description from its homepage
    #
    # @author [guillaumeh]
    #
    class Description
      attr_reader :text

      #
      # Instanciate a new Homebrew::Formula::Description
      # @param  formula [Homebrew::Formula] Formula for which the description
      #   has to be extracted
      #
      # @return [Homebrew::Formula::Description] Returns a new instance of
      #   Homebrew::Formula::Description
      def initialize(formula)
        @formula = formula
        @text = nil
      end

      #
      # Look up for a description in the given string
      # @param  content [String] String containing somewhere the description
      #
      def lookup_from(content)
        @html = Nokogiri::HTML(content)
        grab_description
      end

      #
      # Determine if a description has been found
      #
      # @return [Boolean] true if a description has been found otherwise false
      def found?
        @text.present?
      end

      private

      def software_description_strategy
        case @formula.detected_service
        when :github
          SoftwareDescriptionFetchers::Strategies::Github.new(@html)
        when :google_code
          SoftwareDescriptionFetchers::Strategies::GoogleCode.new(@html)
        else
          SoftwareDescriptionFetchers::Strategies::Default.new(
            @html, name: @formula.name, filename: @formula.filename
          )
        end
      end

      def grab_description
        @text = software_description_strategy.fetch
      end
    end
  end
end
