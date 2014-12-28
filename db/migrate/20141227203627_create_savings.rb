class CreateSavings < ActiveRecord::Migration
  def change
    create_table :savings do |t|
      t.string :institution_name
      t.string :description
      t.decimal :amount
      t.integer :category
      t.belongs_to :background, index: true
      t.belongs_to :plan, index: true

      t.timestamps
    end
  end
end
