class AddColumnToTempLicense < ActiveRecord::Migration
  def change
    add_reference :temp_licenses, :broker, index: true
  end
end
