class AddColumn3ToBrokerRequest < ActiveRecord::Migration
  def change
    add_column :broker_requests, :admin_reply, :string
  end
end
