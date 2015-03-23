class AddAttachmentIdentificationToTempBrokers < ActiveRecord::Migration
  def self.up
    change_table :temp_brokers do |t|
      t.attachment :identification
    end
  end

  def self.down
    remove_attachment :temp_brokers, :identification
  end
end
