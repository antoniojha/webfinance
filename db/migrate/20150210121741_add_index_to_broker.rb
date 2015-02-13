class AddIndexToBroker < ActiveRecord::Migration
  def change
    add_index :brokers, :confirmation_number
   
  end
end
