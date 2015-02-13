class AddIndexToSpending < ActiveRecord::Migration
  def change
    add_index :spendings, :user_id
  end
end
