class AddUserIdToSpendings < ActiveRecord::Migration
  
  def change
    add_column :spendings,:user_id, :integer
  end
end
