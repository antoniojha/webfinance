class ProductQuestion < ActiveRecord::Base
  belongs_to :product_fin_category_rel
  belongs_to :user
  belongs_to :broker
end
