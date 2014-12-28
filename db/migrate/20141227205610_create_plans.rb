class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :description
      t.integer :category
      t.datetime :start_date
      t.datetime :maturity_date
      t.integer :year_duration
      t.decimal :start_amount
      t.decimal :goal_amount
      t.decimal :monthly_cost
      t.decimal :monthly_return
      t.decimal :interest_rate
      t.belongs_to :goal, index: true

      t.timestamps
    end
  end
end
