require 'sneakers/tasks'

namespace :rabbitmq do
  desc "Connect consumer to producer"
  task :setup do
    require "bunny"
    connection = Bunny.new(:host => "rabbitmq", :user => "user", :password => "password", :durability => false)
    connection.start
    channel = connection.create_channel
    messages = channel.queue('instabug.messages')
    chats = channel.queue('instabug.chats')

    connection.close
  end
end