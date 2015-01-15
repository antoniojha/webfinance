class AddColumnToPropertee2 < ActiveRecord::Migration
  def change
    add_column :propertees, :fixed_expense_id, :integer
  end
end
