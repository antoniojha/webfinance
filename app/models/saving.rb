class Saving < ActiveRecord::Base
  belongs_to :background
  belongs_to :plan
  
end
