class AddImageCroppedToUser < ActiveRecord::Migration
  def change
    add_column :users, :image_cropped, :boolean
  end
end
