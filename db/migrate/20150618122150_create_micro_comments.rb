class CreateMicroComments < ActiveRecord::Migration
  def change
    create_table :micro_comments do |t|
      t.belongs_to :user, index: true
      t.belongs_to :broker, index: true
      t.belongs_to :financial_story, index: true
      t.text :description

      t.timestamps
    end
  end
end
