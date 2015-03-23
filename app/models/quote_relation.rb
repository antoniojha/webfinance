class QuoteRelation < ActiveRecord::Base
  belongs_to :user
  belongs_to :broker
  has_one :quote_requirement
  validates :broker_id, :user_id, :product_type, presence: true
  
  # notify broker if a user request for a quote
  
  def send_email_notification(broker,user,product_type)
    email=broker.email
    BrokerNotifier.quote_request_notification(broker,user,product_type).deliver
  end
end
