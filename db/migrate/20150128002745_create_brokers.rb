class CreateBrokers < ActiveRecord::Migration
  def change
    create_table :brokers do |t|
      t.string :first_name
      t.string :last_name
      t.string :institution_name
      t.text :institution_address
      t.string :phone_number
      t.string :email
      t.string :password_digest
      t.string :gender

      t.timestamps
    end
  end
end
