class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.string :description
      t.decimal :amount
      t.datetime :start_date
      t.datetime :maturity_date
      t.boolean :completed
      t.integer :priority
      t.belongs_to :background, index: true

      t.timestamps
    end
  end
end
