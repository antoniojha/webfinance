class AddYodleeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :yodlee_username, :string
    add_column :users, :yodlee_password, :string
  end
end
