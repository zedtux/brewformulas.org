require 'open-uri'
require 'open_uri_redirections'
require 'nokogiri'

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
  # Fetch the given home page remove all Hyphen if any and convert to UTF-8
  #
  # @return [String] Homepage content
  def fetch
    content = fetch_content_from(@url)
    content = follow_http_equiv_refresh(content)
    clean_hyphen_and_non_utf8!(content)
  rescue OpenURI::HTTPError => error
    raise NotAccessibleError, error.message
  end

  private


  #
  # Fetch the HTML content from a given URL
  # @param url [String] URL from where to fetch the content
  #
  # @return [String] HTML content of the given URL
  def fetch_content_from(url)
    open(url, allow_redirections: :all).read
  end

  #
  # In case the returned page contains the following meta node:
  #
  #   <meta http-equiv="refresh" content="0;url=home.html">
  #
  # Then follow the refresh request
  #
  # @param content [String] page content used to detect a refresh meta node
  #
  # @return [String] HTML content of the URL from the refresh meta node
  #   otherwise the content param
  def follow_http_equiv_refresh(content)
    meta_refresh = Nokogiri::HTML(content).at('meta[http-equiv="refresh"]')
    return content unless meta_refresh

    new_path = meta_refresh['content'][/URL=\s+?(.+)/i, 1].gsub(/['"]/, '')
    fetch_content_from([@url, new_path].join('/'))
  end

  def clean_hyphen_and_non_utf8!(content)
    content.gsub!(/&shy;/, '') # Remove all Hyphen
    content.encode(
      'UTF-8',
      invalid: :replace,
      undef: :replace,
      replace: '?'
    ) # Manage non UTF-8 characters
  end
end
