class CreateSuggestedGoals < ActiveRecord::Migration
  def change
    create_table :suggested_goals do |t|
      t.string :description
      t.decimal :amount
      t.integer :category
      t.datetime :maturity_date
      t.belongs_to :background, index: true

      t.timestamps
    end
  end
end
