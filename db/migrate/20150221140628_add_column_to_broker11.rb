class AddColumnToBroker11 < ActiveRecord::Migration
  def change
    add_column :brokers, :status, :string
  end
end
