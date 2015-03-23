class Product < ActiveRecord::Base
  belongs_to :firm
  has_many :appointments
  has_many :brokers, through: :appointments
  
  def self.return_dropdown_lists(firm_id)
    array=[]
    where(firm_id:firm_id).each do |product|
      temp_array=[]
      temp_array=[product.name,product.id]
      array << temp_array
    end
    return array
  end
end
