class AddColumn3ToPrivateMessage < ActiveRecord::Migration
  def change
    add_column :private_messages, :receiver_customer_id, :integer
  end
end
