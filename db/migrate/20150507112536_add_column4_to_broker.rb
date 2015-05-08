class AddColumn4ToBroker < ActiveRecord::Migration
  def change
    add_column :brokers, :salt, :string
  end
end
