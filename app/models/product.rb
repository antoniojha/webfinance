class Product < ActiveRecord::Base
  has_many :financial_stories, dependent: :destroy
  has_many :financial_testimonies, dependent: :destroy
  has_many :broker_product_rels, dependent: :destroy
  has_many :brokers, through: :broker_product_rels
end
