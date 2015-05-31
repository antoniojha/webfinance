class Experience < ActiveRecord::Base
  belongs_to :broker
  validates :company, :title, presence:true, on: :create
  validates :begin_date, :end_date, presence:true, on: :create, if: :not_current_experience?
  
  def not_current_experience?
    current_experience==false
  end
  
end
