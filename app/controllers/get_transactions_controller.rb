class GetTransactionsController < ApplicationController
  def create
    account=Account.find_by_id(params[:account_id])
    @total_data=Hashie::Mash.new
    i=1
    
    # Transaction Query logic follows the 1st option given in https://developer.yodlee.com/Knowledge_Base/Transactions
    higher_limit=500
    lower_limit=1
    end_number=100
    start_number=1
    data=account.yodlee.transaction_data(params[:item_account_id],higher_limit,lower_limit, end_number,start_number)
    begin 
      higher_limit=data.countofAllTransaction
      identifier=data.searchIdentifier
      i=1
      j=2
      count=100
      begin   
        tdata=transaction_data_view(identifier, i,j)
        i=i+1
        j=j+1
        count=count*i
      end while (data.NumberOfHits <count)
      data=account.yodlee.transaction_data(params[:item_account_id],higher_limit,lower_limit, end_number,start_number)
    end while (data.NumberOfHits < data.countOfAllTransaction)
      j=1
      begin 
        end_number=j*100
        start_number=(j-1)*100+1
        data=account.yodlee.transaction_data(params[:item_account_id],higher_limit,lower_limit, end_number,start_number)
        @total_data=@total_data.merge(Hashie::Mash.new(data))
        j=j+1
      end while (j<6)  
      
      i=i+1
  #  end while (data.numberOfHits>0)
      
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
