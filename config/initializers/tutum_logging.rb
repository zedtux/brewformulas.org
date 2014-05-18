# When running on Tutum.co platform, redirect the logs to the standard output
# so that they are accessible from the Tutum.co dashboard
if ENV.key?('TUTUM')
  puts "Running brewformulas.org on Tutum.co ..."
  Rails.logger = Logger.new(STDOUT)
end
