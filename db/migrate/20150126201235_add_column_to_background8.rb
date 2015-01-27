class AddColumnToBackground8 < ActiveRecord::Migration
  def change
    add_column :backgrounds, :total_mortgage, :decimal, default: 0
    add_column :backgrounds, :total_education, :decimal, default: 0
    add_column :backgrounds, :total_protection_need, :decimal, default: 0
  end
end
