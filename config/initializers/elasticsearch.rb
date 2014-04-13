elasticsearch_host = ENV["ELASTICSEARCH_PORT_9200_TCP_ADDR"] || ENV["ELASTICSEARCH_HOST"] || "localhost"
elasticsearch_port = ENV["ELASTICSEARCH_PORT_9200_TCP_PORT"] || ENV["ELASTICSEARCH_PORT"] || 9200

Elasticsearch::Model.client = Elasticsearch::Client.new host: "#{elasticsearch_host}:#{elasticsearch_port}"
