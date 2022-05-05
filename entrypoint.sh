#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /instabug/tmp/pids/server.pid

echo "Running rabbitmq healthcheck..."
echo "Waiting for rabbitmq to get healthy..."
timeout 300 bash -c "until curl --silent --output /dev/null http://$RABBITMQ_HOST:15672/; do printf '.'; sleep 5; done; printf '\n'"

echo "Running elasticsearch healthcheck..."
echo "Waiting for elasticsearch to get healthy..."
timeout 300 bash -c "until curl --silent --output /dev/null http://$ELASTICSEARCH_HOST:9200/_cat/health?h=st; do printf '.'; sleep 5; done; printf '\n'"

if [ -z $WORKER ]
then
    rake app:bootstrap;
fi

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"