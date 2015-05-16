class AddToProductFinCategoryRel < ActiveRecord::Migration
  def change
    add_index :product_fin_category_rels, [:product_id, :vehicle_type], unique: true
  end
end
