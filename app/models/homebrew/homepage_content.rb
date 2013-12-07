require "open-uri"
require "open_uri_redirections"

#
# Get the HTML code from the home page
# of a Homebrew formula, do some cleaning
# and UTF-8 conversion
#
# @author [guillaumeh]
#
module Homebrew
  class HomepageContent
    def initialize(formula)
      @formula = formula
    end

    #
    # Fetch the given formula's home page
    # remove all Hyphen if any
    # and convert to UTF-8
    #
    # @return [String] Formula homepage content
    def fetch
      # Load homepage HTML code
      page_content = open(@formula.homepage, allow_redirections: :all).read
      page_content.gsub!(/&shy;/, "") # Remove all Hyphen
      page_content.encode(
        "UTF-8",
        invalid: :replace,
        undef: :replace,
        replace: "?"
      ) # Manage non UTF-8 characters
    end
  end
end
