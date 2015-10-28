class License < ActiveRecord::Base
  attr_accessor :addition_error_msg
  mount_uploader :license_image, LicenseImageUploader
  
  belongs_to :broker
  has_one :broker_request, dependent: :destroy
  validates :license_number, :license_type, :expiration_date, :broker_id, presence:true
  validates_presence_of :license_image 
  def self.custom_message
    return "You have upload this type of license already"
  end
  validates_uniqueness_of :license_type, scope: :broker_id, message: custom_message

end
