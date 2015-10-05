class FinancialProduct < ActiveRecord::Base
  belongs_to :company
  belongs_to :broker
end
