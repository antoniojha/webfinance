class CreateBrokerProductRels < ActiveRecord::Migration
  def change
    create_table :broker_product_rels do |t|
      t.belongs_to :broker, index: true
      t.belongs_to :product, index: true

      t.timestamps
    end
  end
end
