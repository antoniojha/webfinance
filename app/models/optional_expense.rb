class OptionalExpense < ActiveRecord::Base
  belongs_to :background
  def cat_name
    Order::EXPENSE_TYPES[category-1][0] unless category.blank?
  end
end
