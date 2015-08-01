class ChangePrivateMessageColumns < ActiveRecord::Migration
  def change
    remove_column :private_messages, :sender_id
    remove_column :private_messages, :sender_type
    remove_column :private_messages, :receiver_id
    remove_column :private_messages, :receiver_type
    rename_column :private_messages, :title, :subject
    add_reference :private_messages, :all_customer, index: true
  end
end
