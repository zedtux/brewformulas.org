require 'open-uri'
require 'open_uri_redirections'

#
# Get the HTML code from a given home page URL
# Do some cleaning and UTF-8 conversion
#
# @author [guillaumeh]
#
class Homepage
  class NotAccessibleError < StandardError; end

  def initialize(url)
    @url = url
  end

  #
  # Fetch the given home page
  # remove all Hyphen if any
  # and convert to UTF-8
  #
  # @return [String] Homepage content
  def fetch
    # Load homepage HTML code
    content = open(@url, allow_redirections: :all).read
    content.gsub!(/&shy;/, '') # Remove all Hyphen
    content.encode(
      'UTF-8',
      invalid: :replace,
      undef: :replace,
      replace: '?'
    ) # Manage non UTF-8 characters

  rescue OpenURI::HTTPError => error
    raise NotAccessibleError, error.message
  end
end
