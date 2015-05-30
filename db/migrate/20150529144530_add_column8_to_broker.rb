class AddColumn8ToBroker < ActiveRecord::Migration
  def change
    add_column :brokers, :product_names, :text
  end
end
