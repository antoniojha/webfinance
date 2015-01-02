class Saving < ActiveRecord::Base
  belongs_to :background
  belongs_to :plan
  def cat_name
    Order::SAVING_TYPES[category-1][0] unless category.blank?
  end
end
