#
# Detect famous platforms base on the given URL.
#
# @author [guillaumeh]
#
class ServiceDetection
  attr_reader :detected_service

  #
  # Initialize a new ServiceDetection instance
  # @param  url [String] Service URL
  #
  def initialize(url)
    @url = url
    detect
  end

  private

  #
  # Detect from the given URL the service.
  #
  # Only the exception are managed here, which
  # means that most of the time we are going to
  # treat all website as unknown, so looking
  # everywhere for the description. Only for some
  # exception where clearly a specific place has
  # been identified like being the product description.
  #
  # For example Github has a description area so we will
  # prefere to use that in order to be sure and fast.
  #
  def detect
    @detected_service = case @url
                        when %r{https?\:\/\/.*github.com\/.*}x
                          :github
                        when %r{https?:\/\/code.google.com\/.*}x
                          :google_code
                        else
                          :unknown
                        end
  end
end
