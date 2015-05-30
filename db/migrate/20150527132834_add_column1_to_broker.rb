class AddColumn1ToBroker < ActiveRecord::Migration
  def change
    add_column :brokers, :step, :string
  end
end
