class AddColumn5ToBroker < ActiveRecord::Migration
  def change
    add_column :brokers, :title, :string
  end
end
