class AddColumnToQuoteRelation3 < ActiveRecord::Migration
  def change
    add_column :quote_relations, :broker_replied?, :boolean, default: false
  end
end
