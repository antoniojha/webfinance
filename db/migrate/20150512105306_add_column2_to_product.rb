class AddColumn2ToProduct < ActiveRecord::Migration
  def change
    add_column :products, :risk_level, :string
  end
end
