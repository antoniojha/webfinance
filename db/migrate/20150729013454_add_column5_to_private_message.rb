class AddColumn5ToPrivateMessage < ActiveRecord::Migration
  def change
    add_column :private_messages, :draft_or_trash, :string
  end
end
