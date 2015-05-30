class CreateFinancialStories < ActiveRecord::Migration
  def change
    create_table :financial_stories do |t|
      t.belongs_to :product, index: true
      t.belongs_to :broker, index: true
      t.string :vehicle_type
      t.text :description

      t.timestamps
    end
  end
end
