class Spending < ActiveRecord::Base
  belongs_to :account_item
#  def initialize(h)
#    h.each {|k,v| self.send("#{k}=",v)}
 # end
end
