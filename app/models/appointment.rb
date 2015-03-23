class Appointment < ActiveRecord::Base
  belongs_to :broker
  belongs_to :product
  validates :broker_id, :product_id, presence: true
end