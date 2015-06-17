class AddColumn1ToFinancialProduct < ActiveRecord::Migration
  def change
    add_column :financial_products, :product_id, :integer, references: :products
  end
end
