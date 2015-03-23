class License < ActiveRecord::Base
  belongs_to :broker
  has_attached_file :picture

  validates_attachment_presence :picture, on: [:create, :update]
  validates_attachment_size :picture, :less_than => 5.megabytes
  validates_attachment :picture, content_type: {content_type: "application/pdf"}
  validates :license_number, :license_type, presence:true
  validates_uniqueness_of :license_type, scope: :broker_id 
  
  serialize :states, Array
end
