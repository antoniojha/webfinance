class AddColumnToFinancialProduct < ActiveRecord::Migration
  def change
    add_reference :financial_products, :broker, index: true
  end
end
