class Chat < ApplicationRecord
  belongs_to :application
  has_many :messages

  after_initialize :get_number
  validates_uniqueness_of :number, scope: :application_id

  def respect_counters
    self.update_sequential_number
    self.application.increment(:chats_count)
    self.application.save!
  end

  def get_number
    if self.number == 0
      key = "chats:#{self.application.id}"
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
    key = "chats:#{self.application.id}"
    self.get_number
    $redis.set(key, self.number.to_s)
    self.save!
  end
end
