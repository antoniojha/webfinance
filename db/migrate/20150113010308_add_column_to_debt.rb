class AddColumnToDebt < ActiveRecord::Migration
  def change
    add_column :debts, :fixed_expense_id, :integer
  end
end
