class PrivateMessagesController < ApplicationController
  before_action :set_menu, only: [:new,:index,:draft,:trash]
  def new
    @item="New Message"
    @message=PrivateMessage.new
  end
  def index
    @item="Inbox"
  end
  
  def draft
    @item="Draft"
  end
  
  def trash
    @item="Trash" 
  end
  
  private
  def set_menu
    @menus=["New Message", "Inbox", "Sent", "Draft", "Trash"]
  end
end
