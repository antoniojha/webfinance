class SetupBroker < ActiveRecord::Base
  attr_accessor :broker_id
  belongs_to :broker
  has_many :licenses, dependent: :destroy
  accepts_nested_attributes_for :licenses
end
