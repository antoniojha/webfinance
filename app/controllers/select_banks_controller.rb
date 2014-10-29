class SelectBanksController < ApplicationController
  before_action :set_banks, only: [:index]
  def index
    
  end
  def create

      if !(params[:bank_id].empty?)
        redirect_to bank_login_url(:bank_id=>params[:bank_id])
      else
        redirect_to select_banks_url
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