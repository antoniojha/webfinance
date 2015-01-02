class Debt < ActiveRecord::Base
  belongs_to :background
  def cat_name
    Order::DEBT_TYPES[category-1][0] unless category.blank?
  end
end
