class CreateTempLicenses < ActiveRecord::Migration
  def change
    create_table :temp_licenses do |t|
      t.belongs_to :temp_broker, index: true
      t.integer :license_type
      t.string :license_number
      t.boolean :approved, default:false
      t.string :states

      t.timestamps
    end
  end
end
