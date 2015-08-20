class ProductFinCategoryRel < ActiveRecord::Base
  belongs_to :product
  validates :product_id, :vehicle_type, presence: true
  validates_uniqueness_of :product_id, :scope=> :vehicle_type
end