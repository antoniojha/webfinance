class AddAttachmentPictureToTempLicenses < ActiveRecord::Migration
  def self.up
    change_table :temp_licenses do |t|
      t.attachment :picture
    end
  end

  def self.down
    remove_attachment :temp_licenses, :picture
  end
end
