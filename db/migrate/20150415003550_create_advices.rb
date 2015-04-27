class CreateAdvices < ActiveRecord::Migration
  def change
    create_table :advices do |t|
      t.string :title
      t.text :content
      t.belongs_to :question, index: true
      t.belongs_to :broker, index: true

      t.timestamps
    end
  end
end
