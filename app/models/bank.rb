class Bank < ActiveRecord::Base
  def yodlee
    @yodlee ||=Yodlee::Bank.new(self)
  end

end
