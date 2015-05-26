class CreateExperiences < ActiveRecord::Migration
  def change
    create_table :experiences do |t|
      t.string :title
      t.string :company
      t.string :location
      t.text :description
      t.date :begin_date
      t.date :end_date
      t.belongs_to :broker, index: true

      t.timestamps
    end
  end
end
