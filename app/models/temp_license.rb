class TempLicense < ActiveRecord::Base
  belongs_to :temp_broker
  has_attached_file :picture
  
  validates_attachment :picture, content_type: {content_type: "application/pdf"} # required starting paperclip 4.0
  serialize :states, Array
end
