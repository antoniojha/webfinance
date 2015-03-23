class AddAttachmentIdentificationToBrokers < ActiveRecord::Migration
  def self.up
    change_table :brokers do |t|
      t.attachment :identification
    end
  end

  def self.down
    remove_attachment :brokers, :identification
  end
end
