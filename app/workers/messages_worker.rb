class MessagesWorker
  include Sneakers::Worker

  from_queue "instabug.messages", env: nil, :durable => false

  def work(message_json)
    puts "Consuming message!"
    puts message_json

    deserialized = JSON.parse(message_json)
    ActiveRecord::Base.connection_pool.with_connection do
      Message.transaction do
        message = Message.new(content: deserialized['content'], chat_id: deserialized['chat_id'])

        if message.save!
          message.respect_counters
        else
          puts "Transaction failed!\nCouldn't create message on chat with id #{deserialized['chat_id']}"
          raise ActiveRecord::Rollback
        end
      end
    end
    ack!
  end
end