class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.integer :product_type
      t.belongs_to :firm, index: true

      t.timestamps
    end
  end
end
