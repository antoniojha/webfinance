class AddColumnToLicense4 < ActiveRecord::Migration
  def change
    add_column :licenses, :states, :string
  end
end
