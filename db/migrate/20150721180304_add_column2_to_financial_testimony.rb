class AddColumn2ToFinancialTestimony < ActiveRecord::Migration
  def change
    add_reference :financial_testimonies, :product, index: true
  end
end
