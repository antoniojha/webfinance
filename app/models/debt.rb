class Debt < ActiveRecord::Base
  belongs_to :background
  validates :institution_name, :description, :amount, :category, :interest_rate, presence: true, unless: :empty_field
  validates :amount,numericality:{greater_than: 0.0 }, allow_blank:true
  validates :interest_rate, numericality:{greater_than_or_equal_to: 0,less_than_or_equal_to:100}, allow_blank:true
  def cat_name
    Order::DEBT_TYPES[category-1][0] unless category.blank?
  end
  def empty_field
    if (institution_name.blank? && description.blank? && interest_rate.blank? && amount.blank? && category.blank?)
      return true
    else
      return false
    end
  end
end
