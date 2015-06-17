class FinancialProduct < ActiveRecord::Base
  belongs_to :company
  has_many :financial_product_rels, dependent: :destroy
  has_many :brokers, through: :financial_product_rels
  validates :name, :company_id, presence:true
end
