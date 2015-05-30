class AddColumn7ToBroker < ActiveRecord::Migration
  def change
    add_column :brokers, :company_name, :string
    add_column :brokers, :company_location, :string
  end
end
