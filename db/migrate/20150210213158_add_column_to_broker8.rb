class AddColumnToBroker8 < ActiveRecord::Migration
  def change
    add_column :brokers, :web, :string
    add_column :brokers, :work_ext, :string
  end
end
