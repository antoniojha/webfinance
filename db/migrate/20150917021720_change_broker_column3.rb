class ChangeBrokerColumn3 < ActiveRecord::Migration
  def change
    change_column :brokers, :email_authen, :boolean, :default=> false
  end
end
