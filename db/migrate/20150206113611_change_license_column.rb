class ChangeLicenseColumn < ActiveRecord::Migration
  def change
    remove_column :licenses, :license_type
    add_column :licenses, :license_type, :integer
  end
end
