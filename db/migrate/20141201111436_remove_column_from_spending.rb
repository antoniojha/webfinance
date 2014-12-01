class RemoveColumnFromSpending < ActiveRecord::Migration
  def change
    remove_column :spendings, :user_id
  end
end
