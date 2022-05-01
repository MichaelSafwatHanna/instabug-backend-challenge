class Chat < ApplicationRecord
    belongs_to :application
    has_many :messages
    validates_uniqueness_of :number, scope: :application_id

    def respect_counters
        self.update_sequential_number
        self.application.increment(:chats_count)
        self.application.save!
    end

    def update_sequential_number
        cache_key = "chats:#{self.application.id}"
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
