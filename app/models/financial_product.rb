class FinancialProduct < ActiveRecord::Base
  belongs_to :company
  belongs_to :broker
  validates :company_id,:product_id, :name,:broker_id, presence:true
  
end
