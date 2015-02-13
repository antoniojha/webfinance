class AddAttachmentPictureToBrokers < ActiveRecord::Migration
  def self.up
    change_table :brokers do |t|
      t.attachment :picture
    end
  end

  def self.down
    remove_attachment :brokers, :picture
  end
end
