# Initialize Elasticsearch client with specified URL or default to localhost:9200
elasticsearch_url = 'http://localhost:9200' # Default URL

Elasticsearch::Model.client = Elasticsearch::Client.new(url: elasticsearch_url)