class PrivateMessagesController < ApplicationController
  before_action :set_menu, only: [:new,:index,:draft,:trash, :sent, :show, :edit]
  before_action :set_sender, only: [:new,:index,:draft,:trash, :sent,:update,:destroy,:edit,:show]
  before_action :set_message, only: [:destroy, :edit]
  before_action :protect_message, only: [:edit,:show,:update,:destroy]
  def create
   
    if params[:send_message]
      @message=PrivateMessage.new(message_params)
      
      @message.should_validate=true
      if send_message(@message)
        redirect_to private_messages_path
      else
        set_menu
        set_sender
        render "private_messages/new"
      end
    elsif params[:save_draft]
      @message=PrivateMessage.new(message_params)
      @message.location="draft"
      
      if @message.save
        flash[:info]="Your draft has been saved!"
        redirect_to private_messages_path
      else
        render "private_messages/new"
      end
    end
  end
  def update
    if params[:send_draft]
      # set_message is not in call-back because move message uses update method and passes in a default id=1 which is not meant to look up any private message.
      set_message
      @message.assign_attributes(message_params)
      @message.should_validate=true
      if send_message(@message)
        redirect_to private_messages_path
      else
        set_menu
        set_sender
        render "private_messages/edit"
      end
    else
      if params[:move_message_ids]
        if params[:trash]
          params[:move_message_ids].each do |id|
            message=PrivateMessage.find(id)
            message.update(:location=>"trash")
          end    
        end
      elsif params[:move_back]
        
        set_message
        if @message.sent_or_received
          if @message.sent_or_received=="sent"
            @message.update(:location=>"sent")
          elsif @message.sent_or_received=="received"
            @message.update(:location=>"inbox")
          end
        else
          @message.update(:location=>"draft")
        end

      end
      repopulate_messages
      respond_to do |format|
        format.js{}
        format.html{redirect_to_original_path(@message)}
      end
    end
  end
  def new
    @item="New Message"
    @message=PrivateMessage.new
  end
  def show
    @message=PrivateMessage.find(params[:id])
    
    if @message.sent_or_received=="received"
      
      # this retrieves the original message if there is any replying message
      if @message.original_message_id
        @original_message=PrivateMessage.find(@message.original_message_id)
      else
        @original_message=@message
      end
    else
      @original_message=PrivateMessage.find(@message.original_message_id)
    end
    if @message.sent_or_received =="sent"
      @messages=@message.previous_messages("sent").order(created_at: :asc)
    elsif @message.sent_or_received=="received"
      @messages=@message.previous_messages("all").order(created_at: :asc)
    end
    @sent_from=@original_message.all_customer
    @new_message=PrivateMessage.new
  end
  def index
    @item="Inbox"
    @messages=PrivateMessage.where(:receiver_customer_id=>@sender.id).where(replied:false).where(:sent_or_received=>"received").where(:location=>"inbox").order(created_at: :desc)
  end
  def destroy
    if @message.original_message_id && @message.sent_or_received=="received"
      # if any of the following messages is deleted, the original message plus all of the replies will  be deleted as well.
      begin
    
        @original_message=PrivateMessage.find(@message.original_message_id)
        @messages=@original_message.previous_messages("received")
        @messages.destroy_all
        @original_message.destroy
      rescue
        @message.destroy
      end
    else
      @messages=@message.previous_messages("received")
      # in case the original message is deleted, all the following messages will be deleted as well
      if @messages.count >0
        @messages.destroy_all
      else
        @message.destroy
      end
    end
    repopulate_messages
    respond_to do |format|
      format.js{}
      format.html{redirect_to private_messages_draft_path}
    end    
  end
  def draft
    @item="Draft"
    @messages=@sender.private_messages.where(:location=>"draft").order(created_at: :desc)
  end
  def sent
    @item="Sent"
    @messages=@sender.private_messages.where(:sent_or_received=>"sent").where(:location=>"sent").order(created_at: :desc)
  end
  def trash
    @item="Trash" 
    @messages1=PrivateMessage.where(:sent_or_received=>"received").where(:receiver_customer_id=>@sender.id).where(:location=>"trash").where(replied:false)
    @messages2=@sender.private_messages.where(:sent_or_received=>"sent").where(:location=>"trash")
    @messages=(@messages1+@messages2).sort_by(&:created_at).reverse
    
  end
  
  private
  def set_message
    @message=PrivateMessage.find(params[:id])
  end
  def set_menu
    @menus=["New Message", "Inbox", "Sent", "Draft", "Trash"]
  end
  def message_params
    params.require(:private_message).permit(:all_customer_id, :content,:subject, :receiver_customer_id, :sender_name, :followed_message_id,:original_message_id)
  end
  def redirect_to_original_path(message)
    if message.sent_or_received
      if message.sent_or_received=="sent"
        redirect_to private_message_sent_path
      elsif message.sent_or_received=="received"
        redirect_to private_messages_path
      end
    else
      redirect_to private_messages_draft_path
    end   
  end
  def protect_message
    begin
      message=PrivateMessage.find(params[:id])
      @me=set_sender
      if (@me.id != message.all_customer_id && @me.id !=message.receiver_customer_id)
        flash[:danger]="You can't access other's message!"
        redirect_to private_messages_path
      end
    rescue
    end
  end
  def repopulate_messages 
    #this method queries approriate messages to be display in each location
    self.send(params[:location])
  end
  def set_sender
    if broker_logged_in?
      @sender=current_broker.all_customer
    elsif user_logged_in?
      @sender=current_user.all_customer
    end
  end
  # send_message creates two messages- one in the sender's sent box and one in the receiver's inbox
  def send_message(message)
    if message.receiver_customer_id
      receiver=AllCustomer.find(message.receiver_customer_id).customer
      message.receiver_name=full_name(receiver)
      message.user_or_broker=receiver.class.name
    end
   
    message.sent_or_received="sent"  
    message.location="sent"
    if message.save
      sender=message.all_customer.customer #sender
      track_activity(message,sender,receiver,"create")
      if params[:private_message][:followed_message_id]
        followed_message=PrivateMessage.find(params[:private_message][:followed_message_id])
        if followed_message.followed_message_id
          follow_followed_message=PrivateMessage.find(followed_message.followed_message_id)  
          follow_followed_message.update_attribute(:replied,true)
          # the reason that it goes up two messages is that to ensure that after you have replied a message, the message you've replied stays in your inbox until the repondent writes you a new message
        end
      end
      message.reload
      # create another message to be stored in the inbox of another user
      message_inbox=message.dup
      message_inbox.sent_or_received="received"
      message_inbox.location="inbox"
      message_inbox.save
      flash[:info]="Your message has been sent!"
      return true
      
    else
      @message=message
      return false 
    end
  end
end
