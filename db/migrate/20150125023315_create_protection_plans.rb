class CreateProtectionPlans < ActiveRecord::Migration
  def change
    create_table :protection_plans do |t|

      t.decimal :total_need
      t.integer :start_year
      t.integer :start_month
      t.integer :end_year
      t.integer :end_month

      t.timestamps
    end
  end
end
