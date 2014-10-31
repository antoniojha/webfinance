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
   
      else
        format.html{
          set_banks
          flash[:notice]='Please select a bank'
          render action:'new'
          }
      end
    end
  end
  def bank_login
    @bank=Bank.find_by_content_service_id(params[:bank_id])
    @input_form=@bank.yodlee.form
  end
  private
  def set_banks
    if Bank.all.count > 1
    @banks=Bank.all.order(:content_service_display_name)
    else
    @banks=Bank.first
    end
  end
end