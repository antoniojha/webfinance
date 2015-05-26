class CreateEducations < ActiveRecord::Migration
  def change
    create_table :educations do |t|
      t.string :school
      t.string :degree
      t.date :begin_date
      t.date :end_date
      t.text :description
      t.string :honors
      t.belongs_to :broker, index: true

      t.timestamps
    end
  end
end
