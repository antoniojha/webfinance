class CreateFinancialProducts < ActiveRecord::Migration
  def change
    create_table :financial_products do |t|
      t.string :name
      t.text :description
      t.belongs_to :company, index: true

      t.timestamps
    end
  end
end
