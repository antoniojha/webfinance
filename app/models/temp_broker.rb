class TempBroker < ActiveRecord::Base
 
  belongs_to :broker
  has_many :temp_licenses
  attr_accessor :custom_validates
  serialize :license_type, Array
  attr_writer :phone_work_1, :phone_work_2, :phone_work_3, :phone_cell_1, :phone_cell_2, :phone_cell_3  

  before_validation :remove_empty_licenses
  validate :validates_new_id
  has_attached_file :identification
  validates :broker_id, uniqueness:{scope: :edit_type,message: "should have only one update at once"}
  validates_attachment_size :identification, :less_than => 5.megabytes
  validates_attachment :identification, content_type: {content_type: "application/pdf"}
  serialize :license_type_edit, Array
  serialize :license_type_remove, Array

  def build_licenses
    self.license_type.each do |i|
      license=self.temp_licenses.build
      license.license_type=i
    end
  end
  def validates_new_id
    if @custom_validates
    errors.add(:identification,"a new identification must be provided when name is changed")
    end
  end
  def remove_empty_licenses
    license_type.reject! { |l| l.empty? }
  end
end
