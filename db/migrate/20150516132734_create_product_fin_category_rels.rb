class CreateProductFinCategoryRels < ActiveRecord::Migration
  def change
    create_table :product_fin_category_rels do |t|
      t.integer :vehicle_type
      t.belongs_to :product, index: true
      t.text :description

      t.timestamps
    end
  end
end
