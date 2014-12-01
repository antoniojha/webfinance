class ChangeSpendingColumnName < ActiveRecord::Migration
  def change
    remove_column :spendings,:type
    add_column :spendings, :category, :string
  end
end
