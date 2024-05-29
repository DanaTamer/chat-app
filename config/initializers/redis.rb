require 'redis'

redis_config = { url: "redis://redis:6379" }
begin
  $redis = Redis.new(redis_config)
rescue Exception => e
  puts e
end

begin
  $redis_lock = Redlock::Client.new(["redis://redis:6379/1"])
rescue Exception => e
  puts e
end
