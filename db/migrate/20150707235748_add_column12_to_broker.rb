class AddColumn12ToBroker < ActiveRecord::Migration
  def change
    add_column :brokers, :image_status, :string
  end
end
