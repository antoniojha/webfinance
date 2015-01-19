class AddColumnToBackground2 < ActiveRecord::Migration
  def change
    add_column :backgrounds, :year, :integer
    add_column :backgrounds, :month, :integer
  end
end
