class AddColumn15ToBroker < ActiveRecord::Migration
  def change
    add_column :brokers, :approved, :boolean
  end
end
