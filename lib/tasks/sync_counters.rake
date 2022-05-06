# frozen_string_literal: true

namespace :app do
  desc 'Sync Chats/Messages Counters'
  task sync_counters: :environment do
    ActiveRecord::Base.transaction do
      app_chats_count = Chat.select('application_id', 'count(id) as count').group('application_id')
      app_chats_count.each do |c|
        app = Application.find_by(id: c.application_id)
        app.update(chats_count: c.count)
        app.save
      end

      chat_messages_count = Message.select('chat_id', 'count(id) as count').group('chat_id')
      chat_messages_count.each do |m|
        chat = Chat.find_by(id: m.chat_id)
        chat.update(messages_count: m.count)
        chat.save
      end

      puts "#{Time.now.strftime('%Y-%d-%m %H:%M:%S %Z')} Sync done"
    end
  end
end
