class AddColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :budget_cat, :boolean
    add_column :users, :accounts_cat, :boolean
    add_column :users, :alarm_cat, :boolean
    add_column :users, :social_cat, :boolean
    add_column :users, :planning_cat, :boolean
  end
end
