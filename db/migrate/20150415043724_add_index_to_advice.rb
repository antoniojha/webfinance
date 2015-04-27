class AddIndexToAdvice < ActiveRecord::Migration
  def change
    add_column :advices, :advice_category_id, :integer
    add_index :advices, :advice_category_id
  end
end
