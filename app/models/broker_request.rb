class BrokerRequest < ActiveRecord::Base
  include ApplicationHelper
  attr_accessor :create_application_bool, :complement_requests
  belongs_to :broker
  validate :check_all_complement_approved, if: :create_application?
  def check_all_complement_approved
    complement_requests=BrokerRequest.where(broker_id:broker_id,complement:true)
    broker=Broker.find(broker_id)
    complement_requests.each do |r|
      license=License.find(r.license_id)
      unless r.admin_reply=="approve"
        if r.admin_reply=="disapprove"
        errors.add(:complement_requests, "Account for #{full_name(broker)} can't be approved since license(s) number #{license.license_number} was disapproved.")
        elsif r.admin_reply==nil
        errors.add(:complement_requests, "Account for #{full_name(broker)} can't be approved since license(s) number #{license.license_number} has not been approved.")
        end
      end
    end
  end
  def create_application?
    @create_application_bool==true
  end
end
