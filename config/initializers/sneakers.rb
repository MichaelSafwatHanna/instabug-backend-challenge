# frozen_string_literal: true

require 'sneakers'
Sneakers.configure(connection: Bunny.new(host: ENV['RABBITMQ_HOST'], user: ENV['RABBITMQ_USER'],
                                         password: ENV['RABBITMQ_PASS'], durable: false))
