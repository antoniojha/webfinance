class AddColumnToBackground4 < ActiveRecord::Migration
  def change
    add_column :backgrounds, :netspend, :decimal
  end
end
