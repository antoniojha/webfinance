class Income < ActiveRecord::Base
  belongs_to :background
  def cat_name
    Order::INCOME_TYPES[category-1][0] unless category.blank?
  end
end
