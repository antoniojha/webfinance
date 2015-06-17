class FinancialProductRel < ActiveRecord::Base
  belongs_to :financial_product
  belongs_to :broker
end
