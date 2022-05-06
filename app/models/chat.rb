class Chat < ApplicationRecord
  belongs_to :application
  has_many :messages

  validates_uniqueness_of :number, scope: :application_id

  def key
    @key = "chats:#{application.id}"
  end

  def get_number
    if number.zero?
      entry = $redis.get(key)

      if entry.nil?
        self.number = 1
      else
        count = Integer(entry)
        count += 1
        self.number = count
      end
    else
      number
    end
  end

  def assign_number
    get_number
    $redis.set(key, number.to_s)
  end
end
