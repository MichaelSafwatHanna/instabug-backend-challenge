class CreateChats < ActiveRecord::Migration[5.2]
  def change
    create_table :chats do |t|
      t.integer :number, :null => false, :default => 0
      t.integer :messages_count, :null => false, :default => 0

      t.timestamps
    end
  end
end
