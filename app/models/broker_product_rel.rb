class BrokerProductRel < ActiveRecord::Base
  belongs_to :broker
  belongs_to :product
end