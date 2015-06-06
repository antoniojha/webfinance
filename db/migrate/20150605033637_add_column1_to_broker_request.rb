class AddColumn1ToBrokerRequest < ActiveRecord::Migration
  def change
    add_column :broker_requests, :license_id, :integer
  end
end
