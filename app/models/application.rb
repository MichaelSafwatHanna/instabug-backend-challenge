class Application < ApplicationRecord
  has_many :chats
  
  after_initialize :set_token, if: :without_token

  validates :name, presence: true
  validates :chats_count, presence: true
  validates :token, presence: true
  validates_uniqueness_of :token

  def set_token
    self.token = SecureRandom.uuid
  end

  def without_token
    self.token == nil
  end
end
