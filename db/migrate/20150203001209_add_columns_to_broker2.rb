class AddColumnsToBroker2 < ActiveRecord::Migration
  def change
    add_column :brokers, :street, :string
    add_column :brokers, :city, :string
    add_column :brokers, :state, :string
    add_column :brokers, :country, :string
  end
end
