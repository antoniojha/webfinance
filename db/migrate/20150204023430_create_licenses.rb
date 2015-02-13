class CreateLicenses < ActiveRecord::Migration
  def change
    create_table :licenses do |t|
      t.belongs_to :broker, index: true

      t.timestamps
    end
  end
end
