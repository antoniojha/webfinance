class CreateUsers < ActiveRecord::Migration
  def change
    if !table_exists?("users")  
      create_table :users do |t|
        t.string :username
        t.string :email
        t.string :password_digest
        t.boolean :email_authen
        t.timestamps
      end
    end
  end
end
