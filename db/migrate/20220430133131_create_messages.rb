class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.references :chat, foreign_key: true
      t.integer :number, :null => false, :default => 0
      t.text :content, :null => false

      t.timestamps
    end
  end
end
