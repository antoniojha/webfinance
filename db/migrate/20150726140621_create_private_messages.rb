class CreatePrivateMessages < ActiveRecord::Migration
  def change
    create_table :private_messages do |t|
      t.belongs_to :sender, index: true
      t.string :sender_type
      t.belongs_to :receiver, index: true
      t.string :receiver_type
      t.text :content

      t.timestamps
    end
  end
end
