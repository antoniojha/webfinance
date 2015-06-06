class ChangeProductFinCategoryRelsColumn < ActiveRecord::Migration
  def up
    change_column :product_fin_category_rels, :vehicle_type, :string
  end

  def down
    change_column :product_fin_category_rels, :vehicle_type, :integer
  end
end
