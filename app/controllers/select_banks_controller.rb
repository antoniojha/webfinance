class SelectBanksController < ApplicationController
  #before_action :set_banks, only: [:new]
  def new
    @banks=Bank.all.order(:content_service_display_name)
  end
  
  def index
    
  end
  def create
  end
  
  def next_page1
    respond_to do |format|
      if !(params[:bank_id].empty?)
        format.html{redirect_to bank_login_url(:bank_id=>params[:bank_id])}
     #   redirect_to bank_login_url(:bank_id=>params[:bank_id])
      else
        format.html{render action:'new'}
      end
    end
  end
  def bank_login
    @bank_id=params[:bank_id]
  end
  private
  def set_banks
    @banks=Bank.all.order(:content_service_display_name)
  end
end