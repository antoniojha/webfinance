class AddColumnToLicense2 < ActiveRecord::Migration
  def change
    add_column :licenses, :license_number, :string
  end
end
