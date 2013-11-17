Rails.logger.info "Sidekiq using Redis setting redis://#{AppConfig.redis.server}:#{AppConfig.redis.port}/#{AppConfig.redis.db_num} with namespace \"#{AppConfig.redis.namespace}\""

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
