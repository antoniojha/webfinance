class License < ActiveRecord::Base
  attr_accessor :license_type_display
  belongs_to :setup_broker
  
  mount_uploader :license_image, LicenseImageUploader
  validates :license_number, :license_type, :expiration_date, presence:true
  def self.custom_message
    
    return "You have upload this type of license already"
  end
  validates_uniqueness_of :license_type, scope: :setup_broker_id, message: custom_message

end
