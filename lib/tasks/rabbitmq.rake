require 'sneakers/tasks'

namespace :rabbitmq do
    desc "Connect consumer to producer"
    task :setup do
      require "bunny"
      connection = Bunny.new(:host => "rabbitmq", :user => "user", :password => "password", :durability => false)
      connection.start
      channel = connection.create_channel
      queue_restaurants = channel.queue('instabug.messages')
      
      connection.close
    end
end