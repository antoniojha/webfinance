class ChangePrivateMessageColumn < ActiveRecord::Migration
  def change
    rename_column :private_messages, :draft_or_trash,:location
  end
end
