class AddColumn13ToBroker < ActiveRecord::Migration
  def change
    add_column :brokers, :password_reset_send_at, :datetime
  end
end
