class ChangeBrokerRequest2Column < ActiveRecord::Migration
  def change
    remove_column :broker_requests, :license_id
    add_column :broker_requests, :license_id, :integer, references: :licenses
  end
end
