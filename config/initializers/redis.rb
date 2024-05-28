require 'redis'
require 'dotenv/load'

REDIS_HOST = ENV['REDIS_HOST'] || 'redis'
REDIS_PORT = ENV['REDIS_PORT'] || 6379

redis_config = { url: "redis://#{REDIS_HOST}:#{REDIS_PORT}" }

begin
    $redis = Redis.new(redis_config)
    $red_lock = Redlock::Client.new(["redis://#{REDIS_HOST}:#{REDIS_PORT}/1"])
rescue Exception => e
    puts e
end
