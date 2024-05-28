require 'redis'

REDIS_HOST = 'redis'
REDIS_PORT = 6379

redis_config = { url: "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}" }

begin
    $redis = Redis.new(redis_config)
    $red_lock = Redlock::Client.new(["redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}/1"])
rescue Exception => e
    puts e
end
