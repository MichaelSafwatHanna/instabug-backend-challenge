class Message < ApplicationRecord
  belongs_to :chat
  validates_uniqueness_of :number, scope: :chat_id

    def respect_counters
        self.update_sequential_number
        self.chat.increment(:messages_count)
        self.chat.save!
    end

    def update_sequential_number
        cache_key = "messages:#{self.chat.id}"
        count = Rails.cache.read(cache_key)

        if count.nil?
            Rails.cache.write(cache_key, 1)
            self.number = 1;
        else
            count += 1
            self.number = count;
            Rails.cache.write(cache_key, count)
        end
        self.save!
    end
end
