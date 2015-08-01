class AddColumn9ToPrivateMessage < ActiveRecord::Migration
  def change
    add_column :private_messages, :original_message_id, :integer
  end
end
