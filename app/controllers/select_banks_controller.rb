require 'timeout'
class SelectBanksController < ApplicationController
  #before_action :set_banks, only: [:new]
  def new
    set_banks
  end
  
  def next_page1
    respond_to do |format|
      if !(params[:content_service_id].empty?)
        @bank=Bank.find_by_content_service_id(params[:content_service_id])
        format.html{redirect_to bank_login_url(:content_service_id=>params[:content_service_id])}
      else
        format.html{
          set_banks
          flash[:success]='Please select a bank'
          render action:'new'
          }
      end
    end
  end
  def update
    account=Account.find_by_id(params[:account_id])
    
    @data=account.yodlee.transaction_data(params[:item_account_id])
    respond_to do |format|
      if @data
        render 'transaction'
      else
        render 'account'
      end
    end  
  end
  def create    
    login_info=params[:LOGIN]
    password_info=params[:PASSWORD]
    user=User.first
    bank=Bank.find_by_content_service_id(params[:content_service_id])
    account=Account.create!(user:user, bank:bank)
    begin 
      timeout(20) do
        response=account.yodlee.create({"LOGIN"=> login_info, "PASSWORD"=> password_info})
      end
    rescue Timeout::Error
      render action: 'error_page'
    end
#      @response=response.status
#      format.html{render action: 'error_page'}
    account_id=account.reload.id
    respond_to do |format|
      if response
        format.html{redirect_to account_url(:account_id=>account_id)}
      else
        format.html{
          flash.now[:notice]="Login or Password Invalid"
          set_login
          render action: 'bank_login'
          }
      end     
    end    
  end
  def account  
    account=Account.find_by_id(params[:account_id])
    @account=account
   # account=Account.last
    @itemAccountIds=[]
    @accountTypes=[]
    @accountNums=[]
    response=account.yodlee.get_accounts
    if response
      @bank=response.itemDisplayName
      response.itemData.accounts.each_with_index do |a,index|     
        @itemAccountIds<<a.itemAccountId      
        @accountTypes<< a.acctType
        @accountTypes[index][0]=@accountTypes[index][0].upcase
        @accountNums << a.accountNumber
      end
    end
  #  
   # @personal_data=account.yodlee.transaction_data_view(@raw_data.searchIdentifier)
  end
  
  def bank_login
    set_login
  end
  private
  def set_login
    @bank=Bank.find_by_content_service_id(params[:content_service_id])
    @input_form=@bank.yodlee.form

  end
  def set_banks
    if Bank.all.count > 0
      @banks=Bank.all.order(:content_service_display_name)
    else
      @banks=[]
      @banks[0]=Bank.new
    end
  end
end