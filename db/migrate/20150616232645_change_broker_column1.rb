class ChangeBrokerColumn1 < ActiveRecord::Migration
  def change
    rename_column :brokers, :product_names, :products
  end
end
