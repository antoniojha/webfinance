class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.text :description
      t.string :location

      t.timestamps
    end
  end
end
