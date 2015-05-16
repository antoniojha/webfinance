class ChangeColumnInProduct < ActiveRecord::Migration
  def up
   change_column :products, :vehicle_type, :string
  end

  def down
    change_column :products, :vehicle_type, :integer
  end
end
