class AddAttachmentQuoteFileToQuoteRelations < ActiveRecord::Migration
  def self.up
    change_table :quote_relations do |t|
      t.attachment :quote_file
    end
  end

  def self.down
    remove_attachment :quote_relations, :quote_file
  end
end
