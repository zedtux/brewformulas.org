# When running on Tutum.co platform, redirect the logs to the standard output
# so that they are accessible from the Tutum.co dashboard
Rails.logger = Logger.new(STDOUT) if ENV.key?('TUTUM')

Rails.logger.info 'Tutum initialization done.'
