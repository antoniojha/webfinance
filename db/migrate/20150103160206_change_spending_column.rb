class ChangeSpendingColumn < ActiveRecord::Migration
  def change
    change_column :spendings, :category, :integer
  end
end
