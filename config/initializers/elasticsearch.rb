Elasticsearch::Model.client = Elasticsearch::Client.new(host: ENV['ELASTICSEARCH_HOST'])

# Need to be decoupled.
Message.__elasticsearch__.delete_index!
Message.__elasticsearch__.create_index! force: true
Message.__elasticsearch__.refresh_index!
Message.import(force: true)
