class PrivateMessage < ActiveRecord::Base
  attr_accessor :should_validate
  belongs_to :all_customer
  has_many :activities, as: :trackable, dependent: :destroy  
  validates :receiver_customer_id, presence: true, if: :should_validate?
  # return all previous message received with a specified parameter
  def previous_messages(mode)
    if mode == "sent"
      if self.original_message_id
        @message1=PrivateMessage.where(original_message_id:self.original_message_id, all_customer_id:self.all_customer_id).where(['created_at <= ?', self.created_at]) 
        @message2=PrivateMessage.where(original_message_id:self.original_message_id, receiver_customer_id:self.all_customer_id).where(['created_at <= ?', self.created_at]) 
        @messages=@message1+@message2
        @messages.sort_by { |message| message[:created_at] }
        
      end
    elsif mode == "all"
      if self.original_message_id
        @message1=PrivateMessage.where(original_message_id:self.original_message_id, all_customer_id:self.receiver_customer_id).where(['created_at <= ?', self.created_at]) 
        @message2=PrivateMessage.where(original_message_id:self.original_message_id, receiver_customer_id:self.receiver_customer_id).where(['created_at <= ?', self.created_at]) 
        @messages=@message1+@message2
        @messages.sort_by { |message| message[:created_at] }
        
      end
    end
  end
  def should_validate?
    if @should_validate == true
      return true
    else
      return false
    end  
  end
end
