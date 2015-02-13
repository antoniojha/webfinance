class ChangeBrokerColumn < ActiveRecord::Migration
  def change
    rename_column :brokers,:confirmation_number, :confirmation_number_digest
  end
end
