class FixedExpense < ActiveRecord::Base
  belongs_to :background
  validate :transaction_date_before_today
  validates :amount,numericality:{greater_than: 0.0 },allow_blank: true
  validates :description, :company, :amount, :transaction_date,:category, presence: true, unless: :empty_field
  def transaction_date_string
    transaction_date.strftime('%m/%d/%Y') unless transaction_date.blank?
  end
  def transaction_date_string=(transaction_date_str)
    self.transaction_date=Chronic.parse(transaction_date_str)
  end
  def cat_name
    Order::FIXED_EXPENSE_TYPES[category-1][0] unless category.blank?
  end
  def transaction_date_before_today
    if transaction_date && transaction_date > Time.zone.today
      errors.add(:transaction_date, "transaction date has to be before today's date")
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
