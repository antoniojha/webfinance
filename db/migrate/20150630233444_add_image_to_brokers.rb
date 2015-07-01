class AddImageToBrokers < ActiveRecord::Migration
  def change
    add_column :brokers, :image, :string
  end
end
