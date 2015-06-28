if defined?(Peek)
  Peek.into Peek::Views::Mysql2 if defined?(Peek::Views::Mysql2)
  Peek.into Peek::Views::Redis if defined?(Peek::Views::Redis)
  Peek.into Peek::Views::Sidekiq if defined?(Peek::Views::Sidekiq)
  Peek.into Peek::Views::PerformanceBar if defined?(Peek::Views::PerformanceBar)
  Peek.into Peek::Views::Rblineprof if defined?(Peek::Views::Rblineprof)

  if Rails.env.production?
    c = Rails.application.config
    redis_host = ENV["REDIS_PORT_6379_TCP_ADDR"] || ENV["REDIS_HOST"] || "localhost"
    redis_port = ENV["REDIS_PORT_6379_TCP_PORT"] || ENV["REDIS_PORT"] || 6379
    redis_url = ENV["REDIS_URL"] || "redis://#{redis_host}:#{redis_port}/"
    c.peek.adapter = :redis, {
      client: Redis.new(url: redis_url),
      expires_in: 1.hour.to_i
    }
  end
end
