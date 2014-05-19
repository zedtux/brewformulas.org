# When running on Tutum.co platform, redirect the logs to the standard output
# so that they are accessible from the Tutum.co dashboard
if ENV.key?('TUTUM')
  Rails.logger = Logger.new(STDOUT)
end

Rails.logger.info "Tutum initialization done."
