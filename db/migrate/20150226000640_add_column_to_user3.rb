class AddColumnToUser3 < ActiveRecord::Migration
  def change
    add_column :users, :street, :string
    add_column :users, :city, :string
    add_column :users, :state, :string
    add_column :users, :phone_number, :string
  end
end
