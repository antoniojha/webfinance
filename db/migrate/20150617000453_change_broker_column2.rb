class ChangeBrokerColumn2 < ActiveRecord::Migration
  def change
    rename_column :brokers, :products, :product_ids
  end
end
