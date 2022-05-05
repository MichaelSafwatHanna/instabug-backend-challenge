# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.9'

gem 'mysql2', '>= 0.4.4', '< 0.6.0'
gem 'puma', '~> 3.11'
gem 'rails', '~> 5.2.7', '>= 5.2.7.1'

gem 'bootsnap', '>= 1.1.0', require: false

gem 'active_model_serializers'

# RabbitMQ
gem 'bunny', '~> 2.19'
gem 'connection_pool', '~> 2.2', '>= 2.2.5'
gem 'sneakers'

# Redis
gem 'redis'
gem 'redis-namespace'

# Elsaticsearch
gem 'elasticsearch-model'
gem 'elasticsearch-rails'

gem 'rubocop', require: false

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
