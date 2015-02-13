class AddColumnToBroker4 < ActiveRecord::Migration
  def change
    add_column :brokers, :license_type, :string
  end
end
