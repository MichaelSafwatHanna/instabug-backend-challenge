class Message < ApplicationRecord
  belongs_to :chat
  
  validates_uniqueness_of :number, scope: :chat_id
  after_initialize :get_number

    def respect_counters
        self.update_sequential_number
        self.chat.increment(:messages_count)
        self.chat.save!
    end

    def get_number
        if self.number == 0
          key = "messages:#{self.chat.id}"
          entry = $redis.get(key)
    
          if entry.nil?
            self.number = 1
          else
            count = Integer(entry)
            count += 1
            self.number = count
          end
        else
          self.number
        end
    end

    def update_sequential_number
        key = "messages:#{self.chat.id}"
        self.get_number
        $redis.set(key, self.number.to_s)
        self.save!
    end
end
