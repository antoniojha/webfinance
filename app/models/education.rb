class Education < ActiveRecord::Base
  belongs_to :broker
  validates :school, :degree, presence:true
  validates :begin_date, :end_date, presence:true
  validate :begin_before_end
  
  def begin_before_end
    if begin_date && end_date
      if begin_date > end_date
        errors.add(:begin_date, "can't be after end date")
      end
    end
  end
end