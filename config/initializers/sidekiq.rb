def redis_config
    { url: "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}" }
  end

REDIS_HOST = 'redis'
REDIS_PORT = 6379
  
  Sidekiq.configure_server do |config|
    config.redis = redis_config
  end
  
  Sidekiq.configure_client do |config|
    config.redis = redis_config
  end
  