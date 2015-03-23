class AddColumnToBrokerBackups < ActiveRecord::Migration
  def change
    add_column :broker_backups, :license_type, :string
  end
end
