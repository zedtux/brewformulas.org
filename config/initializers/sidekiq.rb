Rails.logger.info "Sidekiq using Redis setting redis://#{AppConfig.redis.server}:#{AppConfig.redis.port}/#{AppConfig.redis.db_num} with namespace \"#{AppConfig.redis.namespace}\""

# We need here the rescue nil has the AppConfig gem
# doesn't support respond_to?
if sidekiq_conf = AppConfig.sidekiq rescue nil
  Rails.logger.info "Sidekiq with authentication"
  require 'sidekiq'
  require 'sidekiq/web'

  Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
    [user, password] == [AppConfig.sidekiq.user, AppConfig.sidekiq.password]
  end
else
  Rails.logger.info "Sidekiq without authentication"
end

Sidekiq.configure_server do |config|
  config.redis = {
    url: "redis://#{AppConfig.redis.server}:#{AppConfig.redis.port}/#{AppConfig.redis.db_num}",
    namespace: AppConfig.redis.namespace
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: "redis://#{AppConfig.redis.server}:#{AppConfig.redis.port}/#{AppConfig.redis.db_num}",
    namespace: AppConfig.redis.namespace
  }
end

Sidetiq.configure do |config|
  # When `true` uses UTC instead of local times (default: false).
  config.utc = false
end
