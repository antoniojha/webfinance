class CreateQuoteRelations < ActiveRecord::Migration
  def change
    create_table :quote_relations do |t|
      t.belongs_to :broker, index: true
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
