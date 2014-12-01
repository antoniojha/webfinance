class GetTransactionsController < ApplicationController
  def create
    account=Account.find_by_id(params[:account_id])
   
    # Transaction Query logic follows the 1st option given in https://developer.yodlee.com/Knowledge_Base/Transactions
    account_item=AccountItem.find_by_item_account_id(params[:item_account_id])
    @total_data=account.yodlee.get_all_transactions(params[:item_account_id])
    Yodlee::Account.save_to_spendings(@total_data, account_item) # save all transaction to database
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
