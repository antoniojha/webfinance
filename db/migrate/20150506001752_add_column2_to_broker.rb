class AddColumn2ToBroker < ActiveRecord::Migration
  def change
    add_column :brokers, :email_authen, :boolean
  end
end
