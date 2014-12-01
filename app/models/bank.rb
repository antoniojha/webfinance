require 'yaml'
class Bank < ActiveRecord::Base
  has_many :accounts
  def yodlee
    @yodlee ||=Yodlee::Bank.new(self)
  end
     
end
