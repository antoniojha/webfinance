class CreateOptionalExpenses < ActiveRecord::Migration
  def change
    create_table :optional_expenses do |t|
      t.string :description
      t.decimal :amount
      t.integer :category
      t.belongs_to :background, index: true

      t.timestamps
    end
  end
end
