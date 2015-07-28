class AddColumn2ToPrivateMessage < ActiveRecord::Migration
  def change
    add_column :private_messages, :title, :string
  end
end
