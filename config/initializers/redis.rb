redis_conection = Redis.new(host: ENV['REDIS'], port: 6379, db: 0)
$redis = Redis::Namespace.new("instabug:#{Rails.env}", redis: redis_conection)