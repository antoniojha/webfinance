class AddAttachmentPictureToFirms < ActiveRecord::Migration
  def self.up
    change_table :firms do |t|
      t.attachment :picture
    end
  end

  def self.down
    remove_attachment :firms, :picture
  end
end
