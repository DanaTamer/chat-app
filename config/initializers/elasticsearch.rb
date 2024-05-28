require 'elasticsearch/model'
require 'dotenv/load'

# Initialize Elasticsearch client with URL from .env file or default to localhost:9200
Elasticsearch::Model.client = Elasticsearch::Client.new(url: ENV['ELASTICSEARCH_URL'] || 'http://localhost:9200')
