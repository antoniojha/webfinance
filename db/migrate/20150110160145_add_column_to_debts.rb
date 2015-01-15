class AddColumnToDebts < ActiveRecord::Migration
  def change
    add_column :debts, :category, :integer
  end
end
