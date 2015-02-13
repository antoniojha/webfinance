class CreateEducationExpenses < ActiveRecord::Migration
  def change
    create_table :education_expenses do |t|
      t.integer :year_born
      t.integer :month_born
      t.decimal :education_cost
      t.string :description
      t.belongs_to :background, index: true

      t.timestamps
    end
  end
end
