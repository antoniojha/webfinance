class ChangeColumnToEducationExpenses < ActiveRecord::Migration
  def change
    remove_column :education_expenses, :year_born
    remove_column :education_expenses, :month_born
    add_column :education_expenses, :age, :integer
  end
end
