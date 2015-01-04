class ChangeDebtColumn < ActiveRecord::Migration
  def change
    change_column :debts, :interest_rate, :decimal, :default => 0 
  end
end
