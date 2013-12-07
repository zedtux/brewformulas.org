#
# Get the HTML code from the home page
# of a Homebrew formula, do some cleaning
# and UTF-8 conversion
#
# @author [guillaumeh]
#
require "open-uri"
require "open_uri_redirections"

module Homebrew
  class HomepageContent
    def initialize(formula)
      @formula = formula
    end

    def fetch
      # Load homepage HTML code
      page_content = open(@formula.homepage, allow_redirections: :all).read
      page_content.gsub!(/&shy;/, "") # Remove all Hyphen
      page_content = page_content.encode(
        "UTF-8",
        invalid: :replace,
        undef: :replace,
        replace: "?"
      ) # Manage non UTF-8 characters
    end
  end
end
