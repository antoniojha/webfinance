class CreateBackgrounds < ActiveRecord::Migration
  def change
    create_table :backgrounds do |t|
      t.string :state
      t.datetime :dob
      t.boolean :married
      t.integer :children
      t.boolean :has_retirement_plan, default:false
      t.boolean :has_emergency_plan, default:false
      t.boolean :has_protection_plan, default:false
      t.boolean :has_estate_plan, default:false
      t.boolean :has_education_plan, default:false
      t.decimal :total_optional_expense
      t.decimal :total_fixed_expense
      t.decimal :total_income
      t.decimal :total_saving
      t.decimal :total_debt

      t.timestamps
    end
  end
end
