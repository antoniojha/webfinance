class AddIndexToBrokerBackups < ActiveRecord::Migration
  def change
    add_column :broker_backups, :broker_id, :integer
    add_index :broker_backups, :broker_id
  end
end
