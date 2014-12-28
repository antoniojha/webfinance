class CreateFixedExpenses < ActiveRecord::Migration
  def change
    create_table :fixed_expenses do |t|
      t.string :description
      t.string :company
      t.decimal :amount
      t.datetime :transaction_date
      t.boolean :alarm
      t.integer :category
      t.integer :insurance_category
      t.belongs_to :background, index: true

      t.timestamps
    end
  end
end
