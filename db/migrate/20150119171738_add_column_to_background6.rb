class AddColumnToBackground6 < ActiveRecord::Migration
  def change
    change_column :backgrounds, :total_optional_expense, :decimal, :default => 0
    change_column :backgrounds, :total_fixed_expense, :decimal, :default => 0 
    change_column :backgrounds, :total_income, :decimal, :default => 0 
    change_column :backgrounds, :total_saving, :decimal, :default => 0 
    change_column :backgrounds, :total_debt, :decimal, :default => 0 
  end
end
