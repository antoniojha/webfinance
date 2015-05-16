class CreateProductQuestions < ActiveRecord::Migration
  def change
    create_table :product_questions do |t|
      t.belongs_to :product_fin_category_rel, index: true
      t.belongs_to :user, index: true
      t.belongs_to :broker, index: true
      t.text :content
      t.integer :vote_count

      t.timestamps
    end
  end
end
