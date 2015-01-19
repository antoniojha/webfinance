class AddColumnToBackground5 < ActiveRecord::Migration
  def change
    add_column :backgrounds, :completed, :boolean
  end
end
