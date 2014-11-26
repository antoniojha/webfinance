class GetTransactionsController < ApplicationController
  def create
    account=Account.find_by_id(params[:account_id])
   
    # Transaction Query logic follows the 1st option given in https://developer.yodlee.com/Knowledge_Base/Transactions

    @total_data=account.yodlee.get_all_transactions(params[:item_account_id])  
    respond_to do |format|
      if @total_data
        format.html{
          render 'transaction'
        }
      else
        format.html{
          flash.now[:notice]="Error Querying Transactions"
          render 'select_banks/account'
        }
      end
    end
  end
end
