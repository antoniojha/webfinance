class Company < ActiveRecord::Base
  has_many :financial_products, dependent: :destroy
  has_many :products, through: :financial_products
end
