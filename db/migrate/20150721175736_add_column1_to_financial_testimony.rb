class AddColumn1ToFinancialTestimony < ActiveRecord::Migration
  def change
    add_column :financial_testimonies, :title, :string
  end
end
