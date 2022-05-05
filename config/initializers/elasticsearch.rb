# frozen_string_literal: true

Elasticsearch::Model.client = Elasticsearch::Client.new(host: ENV['ELASTICSEARCH_HOST'])
