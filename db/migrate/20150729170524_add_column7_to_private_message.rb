class AddColumn7ToPrivateMessage < ActiveRecord::Migration
  def change
    add_column :private_messages, :sent_or_received, :string
  end
end
