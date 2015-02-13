class AddColumnToBroker5 < ActiveRecord::Migration
  def change
    add_column :brokers, :submitted, :boolean, default: false
  end
end
