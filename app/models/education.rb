class Education < ActiveRecord::Base
  belongs_to :broker
  validates :school, :end_date,:begin_date, presence:true
end
