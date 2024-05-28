require 'redis'

# Specify the Redis host and port directly here
REDIS_HOST = 'redis'
REDIS_PORT = 6379

redis_config = { url: "redis://#{REDIS_HOST}:#{REDIS_PORT}" }

begin
    $redis = Redis.new(redis_config)
    $red_lock = Redlock::Client.new(["redis://#{REDIS_HOST}:#{REDIS_PORT}/1"])
rescue Exception => e
    puts e
end
