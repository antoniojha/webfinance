class Spending < ActiveRecord::Base
  def initialize(h)
    h.each {|k,v| self.send("#{k}=",v}
  end
end
