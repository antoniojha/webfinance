class ChangeFinancialProductColumn < ActiveRecord::Migration
  def change
    add_index :financial_products, :product_id
  end
end
