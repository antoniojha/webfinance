class Saving < ActiveRecord::Base
  belongs_to :background
  belongs_to :plan
  validates :institution_name, :description, :amount, :category, presence: true, unless: :empty_field
  validates :amount,numericality:{greater_than: 0.0 },allow_blank: true
  def cat_name
    Order::SAVING_TYPES[category-1][0] unless category.blank?
  end
  def empty_field
    if (institution_name.blank? && description.blank? && amount.blank? && category.blank?) || (_destroy=="true")
      return true
    else
      return false
    end
  end
end
