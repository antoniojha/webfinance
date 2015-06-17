class Experience < ActiveRecord::Base
  belongs_to :broker
  validates :company, :title, presence:true
  validates :begin_date, :end_date, presence:true, if: :not_current_experience?
  
  def not_current_experience?
    current_experience!=true
  end
  validate :begin_before_end
  
  def begin_before_end
    if begin_date && end_date
      if begin_date > end_date
        errors.add(:begin_date, "can't be after end date")
      end
    end
  end
  
  after_update :update_broker_info
  def update_broker_info
#    raise "error"
    if current_experience==true
 
      broker=Broker.find(broker_id)
      if title && company
        broker.update_attributes!(title:title,company_name:company)
      end
    end
  end
end
