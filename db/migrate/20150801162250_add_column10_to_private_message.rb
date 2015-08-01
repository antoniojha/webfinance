class AddColumn10ToPrivateMessage < ActiveRecord::Migration
  def change
    add_column :private_messages, :user_or_broker, :string
  end
end
