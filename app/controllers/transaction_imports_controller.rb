class TransactionImportsController < ApplicationController
  def new
    @import_params=%w(id description transaction_date amount category )
    @transaction_import=TransactionImport.new
  end
  def create
    @import_params=%w(id description transaction_date amount category )
    @transaction_import=TransactionImport.new(transaction_import_params)
    if @transaction_import.save(session[:user_id])
      redirect_to spendings_url, notice: "Imported products successfully."
    else
      render :new
    end
  end

  def transaction_import_params
    params.require(:transaction_import).permit(:file)
  end  
end
