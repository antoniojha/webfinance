class AddColumn6ToPrivateMessage < ActiveRecord::Migration
  def change
    add_column :private_messages, :sender_name, :string
    add_column :private_messages, :receiver_name, :string
  end
end
