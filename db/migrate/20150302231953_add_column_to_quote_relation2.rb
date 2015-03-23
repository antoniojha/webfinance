class AddColumnToQuoteRelation2 < ActiveRecord::Migration
  def change
    add_index :quote_relations, [:user_id, :broker_id,:product_type], unique: true, name:"index_quote_relations"
   
  end
end
