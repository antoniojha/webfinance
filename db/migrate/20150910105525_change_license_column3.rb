class ChangeLicenseColumn3 < ActiveRecord::Migration
  def change
    rename_column :licenses, :image, :license_image
  end
end
