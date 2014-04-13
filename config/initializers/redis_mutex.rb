redis_host = ENV["REDIS_PORT_6379_TCP_ADDR"] || ENV["REDIS_HOST"] || "localhost"
redis_port = ENV["REDIS_PORT_6379_TCP_PORT"] || ENV["REDIS_PORT"] || 6379
redis_url = ENV["REDIS_URL"] || "redis://#{redis_host}:#{redis_port}/"

Redis::Classy.db = Redis.new(url: redis_url)
