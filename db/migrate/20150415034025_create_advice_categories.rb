class CreateAdviceCategories < ActiveRecord::Migration
  def change
    create_table :advice_categories do |t|
      t.string :description

      t.timestamps
    end
  end
end
