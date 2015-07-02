class AddColumn11ToBroker < ActiveRecord::Migration
  def change
    add_column :brokers, :aws_image_path, :string
  end
end
