class AddColumnToBackground3 < ActiveRecord::Migration
  def change
    add_column :backgrounds, :networth, :decimal
  end
end
