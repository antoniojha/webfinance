class AddColumn11ToBroker < ActiveRecord::Migration
  def change
    add_column :brokers, :setup_completed?, :boolean
  end
end
