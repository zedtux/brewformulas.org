redis_conf = Rails.application.config_for(:redis)

redis_url = 'redis://'
if redis_conf['password'].present?
  redis_url << ":#{redis_conf['password']}@"
end
redis_url << "#{redis_conf['host']}:#{redis_conf['port']}/"
redis_url << "#{redis_conf['db']}"

message = 'Sidekiq using Redis setting '
message << redis_url
if redis_conf['namespace']
  message << ' with namespace "'
  message << redis_conf['namespace']
  message << '"'
end
puts message
Rails.logger.info message

# We need here the rescue nil has the AppConfig gem
# doesn't support respond_to?
begin
  fail if Rails.env.development?

  fail unless ENV['SIDEKIQ_USER'] && ENV['SIDEKIQ_PASSWORD']
  Rails.logger.info 'Sidekiq with authentication'

  require 'sidekiq'
  require 'sidekiq/web'

  Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
    [user, password] == [ENV['SIDEKIQ_USER'], ENV['SIDEKIQ_PASSWORD']]
  end
rescue
  Rails.logger.info 'Sidekiq without authentication'
end

Sidekiq.configure_server do |config|
  config.redis = { url: redis_url, namespace: redis_conf['namespace'] }
  config.on(:startup) do
    scheduler_file_path = File.expand_path('../../../config/scheduler.yml',
                                           __FILE__)
    Sidekiq.schedule = YAML.load_file(scheduler_file_path)
    Sidekiq::Scheduler.reload_schedule!
  end
end
Sidekiq.configure_client do |config|
  config.redis = { url: redis_url, namespace: redis_conf['namespace'] }
end
