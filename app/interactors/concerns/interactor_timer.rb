module InteractorTimer
  extend ActiveSupport::Concern

  included do
    around do |interactor|
      begin
        context.start_time = Time.now
        Rails.logger.debug "Interactor #{self.class.name} starts at " \
                           "#{context.start_time}"
        interactor.call
      rescue Interactor::Failure => interactor
        Rails.logger.debug "Interactor #{self.class.name} fails with " \
                           "#{interactor.context.errors.inspect}"
        raise
      ensure
        context.finish_time = Time.now
        running_time = context.finish_time - context.start_time
        Rails.logger.debug "Interactor #{self.class.name} ends at " \
                           "#{context.finish_time} (#{running_time}ms)"
      end
    end
  end
end
