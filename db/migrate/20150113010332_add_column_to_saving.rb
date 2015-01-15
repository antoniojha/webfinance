class AddColumnToSaving < ActiveRecord::Migration
  def change
    add_column :savings, :fixed_expense_id, :integer
  end
end
