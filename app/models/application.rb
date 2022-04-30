class Application < ApplicationRecord
  has_many :chats
  
  before_validation :set_token, if: :has_token

  validates :name, presence: true
  validates :chats_count, presence: true
  validates :token, presence: true

  def set_token
    self.token = SecureRandom.uuid
  end

  def has_token
    self.token == nil
  end
end
