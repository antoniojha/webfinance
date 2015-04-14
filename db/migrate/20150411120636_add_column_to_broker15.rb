class AddColumnToBroker15 < ActiveRecord::Migration
  def change
    add_column :brokers, :time_zone, :string
  end
end
