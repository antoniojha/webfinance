class AddColumnsToBroker < ActiveRecord::Migration
  def change
    add_column :brokers, :phone_number_cell, :string
    add_column :brokers, :longitude, :float
    add_column :brokers, :latitude, :float
  end
end
