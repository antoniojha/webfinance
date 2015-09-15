class AddIdImageToBroker < ActiveRecord::Migration
  def change
    add_column :brokers, :id_image, :string
  end
end
