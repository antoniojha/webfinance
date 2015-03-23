class CreateFirms < ActiveRecord::Migration
  def change
    create_table :firms do |t|
      t.string :name
      t.text :description
      t.string :web
      t.string :business_types
      t.string :product_types

      t.timestamps
    end
  end
end
