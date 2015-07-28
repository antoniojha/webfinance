class AllCustomer < ActiveRecord::Base
  belongs_to :customer, polymorphic:true
end
