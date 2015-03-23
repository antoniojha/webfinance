class BrokerBackup < ActiveRecord::Base
  belongs_to :broker
  serialize :license_type, Array

end
