class ChangeLicenseColumn2 < ActiveRecord::Migration
  def change
    change_column :licenses, :license_type, :string
  end
end
