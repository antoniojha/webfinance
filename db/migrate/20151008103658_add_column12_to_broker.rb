class AddColumn12ToBroker < ActiveRecord::Migration
  def change
    add_column :brokers, :password_confirmation_token, :string
  end
end
