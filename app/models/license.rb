class License < ActiveRecord::Base
  belongs_to :setup_broker
  has_attached_file :picture

  validates_attachment_presence :picture, on: [:create, :update]
  validates_attachment_size :picture, :less_than => 5.megabytes
  validates_attachment_content_type :picture, content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif", "image/pjpeg","application/pdf"]
  validates :license_number, :license_type, presence:true
  validates_uniqueness_of :license_type, scope: :broker_id 

end
