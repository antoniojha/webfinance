class AddAttachmentPictureToLicenses < ActiveRecord::Migration
  def self.up
    change_table :licenses do |t|
      t.attachment :picture
    end
  end

  def self.down
    remove_attachment :licenses, :picture
  end
end
