class License < ActiveRecord::Base
  attr_accessor :license_type_display 
  belongs_to :setup_broker
  has_one :broker_request, dependent: :destroy
  has_attached_file :picture

  validates_attachment_presence :picture, on: [:create, :update]
  validates_attachment_size :picture, :less_than => 5.megabytes
  validates_attachment_content_type :picture, content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif", "image/pjpeg","application/pdf"]
  validates :license_number, :license_type, presence:true
  def self.custom_message
    
    return "You have upload this type of license already"
  end
  validates_uniqueness_of :license_type, scope: :setup_broker_id, message: custom_message

end
