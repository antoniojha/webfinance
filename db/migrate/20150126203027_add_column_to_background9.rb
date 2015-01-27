class AddColumnToBackground9 < ActiveRecord::Migration
  def change
    add_column :backgrounds, :other_debt, :decimal, default: 0
  end
end
