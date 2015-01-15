class CreatePropertees < ActiveRecord::Migration
  def change
    create_table :propertees do |t|
      t.string :description
      t.decimal :amount
      t.integer :category

      t.timestamps
    end
  end
end
