class FixedExpense < ActiveRecord::Base
  belongs_to :background
  def transaction_date_string
    transaction_date.strftime('%m/%d/%Y') unless transaction_date.blank?
  end
  def transaction_date_string=(transaction_date_str)
    self.transaction_date=Chronic.parse(transaction_date_str)
  end
  def cat_name
    Order::FIXED_EXPENSE_TYPES[category-1][0] unless category.blank?
  end
end
