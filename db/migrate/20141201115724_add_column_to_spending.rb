class AddColumnToSpending < ActiveRecord::Migration
  def change
    add_reference :spendings, :account_item, index: true
  end
end
