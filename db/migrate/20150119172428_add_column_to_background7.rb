class AddColumnToBackground7 < ActiveRecord::Migration
  def change
    change_column :backgrounds, :networth, :decimal, :default => 0 
    change_column :backgrounds, :netspend, :decimal, :default => 0 
  end
end
