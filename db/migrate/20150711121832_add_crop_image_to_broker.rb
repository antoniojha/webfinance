class AddCropImageToBroker < ActiveRecord::Migration
  def change
    add_column :brokers, :image_cropped, :boolean
  end
end
