class AddColumn16ToBroker < ActiveRecord::Migration
  def change
    add_column :brokers, :auth_token_digest, :string
  end
end
