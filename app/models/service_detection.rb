#
# Detect famous platforms base on the given URL.
#
# @author [guillaumeh]
#
class ServiceDetection

  #
  # Initialize a new ServiceDetection instance
  # @param  url [String] Service URL
  #
  def initialize(url)
    @url = url
    @service_name = nil
    self.send(:detect)
  end

  #
  # Get the name of the detect service
  #
  # @return [Symbol] name of the detected service
  def detected_service
    @service_name
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
    @service_name = case @url
    when /https?\:\/\/.*github.com\/.*/
      :github
    else
      :unknown
    end
  end
end
