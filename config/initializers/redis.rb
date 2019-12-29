redis = Redis.new(:host => Figaro.env.redis_host, :port => Figaro.env.redis_port)
$redis = Redis::Namespace.new(Figaro.env.redis_namespace, :redis => redis)