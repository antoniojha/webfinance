class AddColumn4ToPrivateMessage < ActiveRecord::Migration
  def change
    add_column :private_messages, :followed_message_id, :integer
  end
end
