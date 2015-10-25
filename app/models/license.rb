class License < ActiveRecord::Base
  attr_accessor :addition_error_msg
  belongs_to :setup_broker
  has_one :broker_request
  mount_uploader :license_image, LicenseImageUploader
  validates :license_number, :license_type, :expiration_date, presence:true
  validates_presence_of :license_image
  def self.custom_message
    return "You have upload this type of license already"
  end
  validates_uniqueness_of :license_type, scope: :setup_broker_id, message: custom_message

end
