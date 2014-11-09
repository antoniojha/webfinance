class SelectBanksController < ApplicationController
  #before_action :set_banks, only: [:new]
  def new
    set_banks
  end
  
  def index
    
  end
  def create
  end
  
  def next_page1
    respond_to do |format|
      if !(params[:content_service_id].empty?)
        @bank=Bank.find_by_content_service_id(params[:content_service_id])
        format.html{redirect_to bank_login_url(:content_service_id=>params[:content_service_id])}
      else
        format.html{
          set_banks
          flash[:notice]='Please select a bank'
          render action:'new'
          }
      end
    end
  end
  def next_page2
    respond_to do |format|
      login_info=params[:account][:LOGIN]
      password_info=params[:account][:PASSWORD]
      user=User.first
      bank=Bank.find_by_content_service_id(params[:content_service_id])
      account=Account.create!(user:user, bank:bank)
      account.yodlee.create({"LOGIN"=> login_info, "PASSWORD"=> password_info})
      if(account)
        session[:account_id]=account.id
        format.html{redirect_to account_url, :account_id=>account.id}
      else
        format.html{
          flash[:notice]="Login or Password Invalid"
          render action: 'next_page1'
          }
      end      
    end    
  end
  def account
    account=Account.last
    @data=account.yodlee.transaction_data
  #  @personal_data=account.yodlee.transaction_data_view(@raw_data.searchIdentifier)
  end
  
  def bank_login
    @bank=Bank.find_by_content_service_id(params[:content_service_id])
    @input_form=@bank.yodlee.form(wrapper: 'account')
  end
  private
  def set_banks
    if Bank.all.count > 0
      @banks=Bank.all.order(:content_service_display_name)
    else
      @banks=[]
      @banks[0]=Bank.new
    end
  end
end