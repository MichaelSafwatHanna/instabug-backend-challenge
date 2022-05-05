# frozen_string_literal: true

class ChatsWorker
  include Sneakers::Worker

  from_queue 'instabug.chats', env: nil, durable: false

  def work(chat_json)
    puts 'Consuming chat!'
    puts chat_json

    deserialized = JSON.parse(chat_json)
    ActiveRecord::Base.connection_pool.with_connection do
      Chat.transaction do
        chat = Chat.new(application_id: deserialized['app_id'], number: deserialized['number'])

        if chat.save!
          chat.respect_counters
        else
          puts 'Transaction failed!'
          puts "Couldn't create chat on application with id #{deserialized['app_id']} and chat number #{deserialized['number']}"
          raise ActiveRecord::Rollback
        end
      end
    end
    ack!
  end
end
