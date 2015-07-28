class CreateAllCustomers < ActiveRecord::Migration
  def change
    create_table :all_customers do |t|
      t.belongs_to :customer, index: true
      t.string :customer_type

      t.timestamps
    end
  end
end
