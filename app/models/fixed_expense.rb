class FixedExpense < ActiveRecord::Base
  belongs_to :background
  validate :transaction_date_this_month
  validates :amount,numericality:{greater_than: 0.0 },allow_blank: true
  validates :description, :amount, :transaction_date,:category, presence: true, unless: :empty_field
  validates :company, presence: true, unless: :empty_field
  def transaction_date_string
    transaction_date.strftime('%m/%d/%Y') unless transaction_date.blank?
  end
  def transaction_date_string=(transaction_date_str)
    self.transaction_date=Chronic.parse(transaction_date_str)
  end
  def cat_name
    Order::FIXED_EXPENSE_TYPES[category-1][0] unless category.blank?
  end
  def transaction_date_this_month
    if transaction_date && transaction_date.month != Time.zone.today.month
      errors.add(:transaction_date, "transaction date has to be in this month")
    end
  end
  def empty_field
    if (description.blank? && company.blank? && amount.blank? && transaction_date.blank? && category.blank?)
      return true
    else
      return false
    end
  end
end
