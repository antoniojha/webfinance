class OptionalExpense < ActiveRecord::Base
  belongs_to :background  
  validates :amount,numericality:{greater_than: 0.0 }, allow_blank:true
  validates :description, :amount, :category, presence: true, unless: :empty_field
  def cat_name
    Order::EXPENSE_TYPES[category-1][0] unless category.blank?
  end
  def empty_field
    if (description.blank? && amount.blank? && category.blank?) || (_destroy==true)
      return true
    else
      return false
    end
  end
end
