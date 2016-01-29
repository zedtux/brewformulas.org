redis_url = 'redis://'
if AppConfig.redis['password'].present?
  redis_url << ":#{AppConfig.redis['password']}@"
end
redis_url << "#{AppConfig.redis.server}:#{AppConfig.redis.port}/"
redis_url << "#{AppConfig.redis.db_num}"

message = 'Sidekiq using Redis setting '
message << redis_url
if AppConfig.redis.try(:namespace)
  message << ' with namespace "'
  message << AppConfig.redis.namespace
  message << '"'
end
Rails.logger.info message

# We need here the rescue nil has the AppConfig gem
# doesn't support respond_to?
begin
  fail if Rails.env.development?
  sidekiq_conf = AppConfig.sidekiq
  Rails.logger.info 'Sidekiq with authentication'
rescue
  Rails.logger.info 'Sidekiq without authentication'
end
if sidekiq_conf
  require 'sidekiq'
  require 'sidekiq/web'

  Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
    [user, password] == [AppConfig.sidekiq.user, AppConfig.sidekiq.password]
  end
end

Sidekiq.configure_server do |config|
  config.redis = { url: redis_url, namespace: AppConfig.redis.try(:namespace) }
end
Sidekiq.configure_client do |config|
  config.redis = { url: redis_url, namespace: AppConfig.redis.try(:namespace) }
end

Sidetiq.configure do |config|
  # When `true` uses UTC instead of local times (default: false).
  config.utc = false
end
