class PrivateMessage < ActiveRecord::Base
  attr_accessor :should_validate
  belongs_to :all_customer
 
  validates :receiver_customer_id, presence: true, if: :should_validate?
  # return all previous message received with a specified parameter
  def previous_messages(mode)
    if mode == "received"
      PrivateMessage.where(original_message_id:self.original_message_id).where(sent_or_received: "received").where(['updated_at < ?', self.updated_at])
    elsif mode == "sent"
      @message1=PrivateMessage.where(original_message_id:self.original_message_id).where(sent_or_received:"sent").where(['updated_at <= ?', self.updated_at]) 
      @message2=PrivateMessage.where(original_message_id:self.original_message_id).where(sent_or_received:"received").where(['updated_at <= ?', self.updated_at]) 
      @messages=@message1+@message2
      @messages.order(updated_at: :asc)
    elsif mode == "all"
      @message1=PrivateMessage.where(original_message_id:self.original_message_id).where(sent_or_received:"sent").where(['updated_at <= ?', self.updated_at]) 
      @message2=PrivateMessage.where(original_message_id:self.original_message_id).where(sent_or_received:"received").where(['updated_at <= ?', self.updated_at]) 
      @messages=@message1+@message2
      @messages.order(updated_at: :asc).drop(@messages.count-1)
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
