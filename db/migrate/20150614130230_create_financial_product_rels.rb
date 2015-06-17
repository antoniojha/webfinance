class CreateFinancialProductRels < ActiveRecord::Migration
  def change
    create_table :financial_product_rels do |t|
      t.belongs_to :financial_product, index: true
      t.belongs_to :broker, index: true

      t.timestamps
    end
  end
end
