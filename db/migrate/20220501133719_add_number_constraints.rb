class AddNumberConstraints < ActiveRecord::Migration[5.2]
  def change
    add_index :chats, [:number, :application_id], unique: true
    add_index :messages, [:number, :chat_id], unique: true
  end
end
