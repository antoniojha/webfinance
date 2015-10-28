class FinancialProduct < ActiveRecord::Base
  belongs_to :company
  belongs_to :broker
  belongs_to :product
  validates :company_id,:product_id, :name,:broker_id, presence:true
  
end
