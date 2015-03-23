class CreateTempBrokers < ActiveRecord::Migration
  def change
    create_table :temp_brokers do |t|
      t.string :first_name
      t.string :last_name
      t.string :institution_name
      t.string :phone_number_work
      t.string :email
      t.string :phone_number_cell
      t.string :street
      t.string :city
      t.string :state
      t.string :country
      t.integer :firm_id
      t.belongs_to :broker, index: true
      t.string :license_type

      t.timestamps
    end
  end
end
