class AddColumnToBroker14 < ActiveRecord::Migration
  def change
    add_column :brokers, :license_type_edit, :string
    add_column :brokers, :license_type_remove, :string
  end
end
