class Product < ActiveRecord::Base
  has_many :financial_products, dependent: :destroy
  has_many :companies, through: :financial_products
  has_many :financial_stories, dependent: :destroy
  has_many :financial_testimonies, dependent: :destroy
  has_many :broker_product_rels, dependent: :destroy
  has_many :brokers, through: :broker_product_rels
  has_many :product_fin_category_rels, dependent: :destroy
end
