class Firm < ActiveRecord::Base
  has_many :brokers
  has_many :products
  serialize :product_types, Array
  serialize :business_types, Array
  
  def self.return_dropdown_lists
    array=[]
    all.each do |firm|
      temp_array=[]
      temp_array=[firm.name,firm.id]
      array << temp_array
    end
    return array
  end
end
