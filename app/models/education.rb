class Education < ActiveRecord::Base
  belongs_to :broker
  validates :school, :degree, presence:true
end
