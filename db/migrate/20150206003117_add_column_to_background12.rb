class AddColumnToBackground12 < ActiveRecord::Migration
  def change
    add_column :backgrounds, :total_property, :decimal, default:0
  end
end
