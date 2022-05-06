ENV.each { |k, v| env(k, v) }

set :output, '/instabug/log/cron.log'

if ENV['RAILS_ENV'] == 'development'
  every 1.minute do
    rake 'app:sync_counters'
  end
else
  every 30.minutes do
    rake 'app:sync_counters'
  end
end
