class AddNumberConstraints < ActiveRecord::Migration[5.2]
  def change
    add_index :chats, %i[number application_id], unique: true
    add_index :messages, %i[number chat_id], unique: true
  end
end
