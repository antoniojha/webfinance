class RenameProductColumn < ActiveRecord::Migration
  def change
    rename_column :products,:product_type,:vehicle_type 
  end
end
