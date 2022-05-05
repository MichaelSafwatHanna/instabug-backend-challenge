# frozen_string_literal: true

require 'bunny'
require 'connection_pool'

class RabbitmqConnection
  include Singleton
  attr_reader :connection

  def initialize
    @connection = Bunny.new(host: ENV['RABBITMQ_HOST'], user: ENV['RABBITMQ_USER'],
                            password: ENV['RABBITMQ_PASS'], durable: false)
    @connection.start
  end

  def channel
    @channel ||= ConnectionPool.new do
      connection.create_channel
    end
  end
end
