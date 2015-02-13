class ChangeLicenseColumn < ActiveRecord::Migration
  def change
    change_column :licenses, :license_type, :integer
  end
end
