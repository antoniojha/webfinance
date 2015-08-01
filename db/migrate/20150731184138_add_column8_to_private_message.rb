class AddColumn8ToPrivateMessage < ActiveRecord::Migration
  def change
    add_column :private_messages, :replied, :boolean, default:false
  end
end
