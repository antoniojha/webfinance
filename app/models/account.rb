class Account < ActiveRecord::Base
  belongs_to :user
  belongs_to :bank
  def yodlee
    @yodlee ||= Yodlee::Account.new(self) 
  end
  
end
