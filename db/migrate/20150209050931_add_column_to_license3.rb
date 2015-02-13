class AddColumnToLicense3 < ActiveRecord::Migration
  def change
    add_column :licenses, :approved, :boolean, default:false
  end
end
