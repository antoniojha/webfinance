class Product < ActiveRecord::Base
  belongs_to :firm
  has_many :financial_products, dependent: :destroy
  has_many :companies, through: :financial_products
  has_many :product_fin_category_rels, dependent: :destroy
  has_many :financial_stories, dependent: :destroy
  has_many :brokers, through: :financial_stories
  
  def self.return_dropdown_lists(firm_id)
    array=[]
    where(firm_id:firm_id).each do |product|
      temp_array=[]
      temp_array=[product.name,product.id]
      array << temp_array
    end
    return array
  end
  def create_product_category_relation
    
  end
end
