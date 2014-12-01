class RemoveColumnFromAccountItem < ActiveRecord::Migration
  def change
    remove_column :account_items, :user_id
  end
end
