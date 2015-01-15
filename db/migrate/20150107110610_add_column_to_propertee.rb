class AddColumnToPropertee < ActiveRecord::Migration
  def change
    add_column :propertees, :background_id, :integer
    add_index :propertees, :background_id
 
  end
end
