class ChangeBrokerColumnName < ActiveRecord::Migration
  def change
    rename_column :brokers, :phone_number, :phone_number_work
  end
end
