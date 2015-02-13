class BrokerImportsController < ApplicationController
  def new
    @broker_import=BrokerImport.new
  end
  def create
 #   @import_params=%w(id first_name last_name institution_name street city state phone_number_work phone_number_cell email web) 
    @broker_import=BrokerImport.new(broker_import_params)
    if @broker_import.save
      redirect_to brokers_url, notice: "Imported Brokers successfully."
    else
      render :new
    end
  end
  def broker_import_params
    params.require(:broker_import).permit(:file)
  end  
end
