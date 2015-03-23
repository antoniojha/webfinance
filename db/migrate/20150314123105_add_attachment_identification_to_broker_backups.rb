class AddAttachmentIdentificationToBrokerBackups < ActiveRecord::Migration
  def self.up
    change_table :broker_backups do |t|
      t.attachment :identification
    end
  end

  def self.down
    remove_attachment :broker_backups, :identification
  end
end
