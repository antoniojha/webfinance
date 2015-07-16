class ChangeColumnsInGoal < ActiveRecord::Migration
  def change
    remove_column :goals, :amount
    remove_column :goals, :start_date
    remove_column :goals, :maturity_date
    remove_column :goals, :completed
    remove_column :goals, :background_id
    add_column :goals, :user_id , :integer, :references => "users"
    
  end
end
