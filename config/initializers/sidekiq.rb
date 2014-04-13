redis_host = ENV["REDIS_PORT_6379_TCP_ADDR"] || ENV["REDIS_HOST"] || "localhost"
redis_port = ENV["REDIS_PORT_6379_PORT"] || ENV["REDIS_PORT"] || 6379
redis_url = ENV["REDIS_URL"] || "redis://#{redis_host}:#{redis_port}/"

Sidekiq.configure_server do |config|
  config.redis = {url: "#{redis_url}", namespace: "seirenes_sidekiq"}
end

Sidekiq.configure_client do |config|
  config.redis = {url: "#{redis_url}", namespace: "seirenes_sidekiq"}
end
