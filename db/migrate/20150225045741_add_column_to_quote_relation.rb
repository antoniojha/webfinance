class AddColumnToQuoteRelation < ActiveRecord::Migration
  def change
    add_column :quote_relations, :product_type, :integer
  end
end
