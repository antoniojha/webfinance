class AddColumnToBackground10 < ActiveRecord::Migration
  def change
    add_column :backgrounds, :income_need, :decimal, default: 0
  end
end
