class AddColumnToBackground < ActiveRecord::Migration
  def change
    add_column :backgrounds, :current_step, :string
  end
end
