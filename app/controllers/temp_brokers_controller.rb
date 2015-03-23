class TempBrokersController < ApplicationController
  before_action :set_temp_broker, only: [:edit, :show, :update]
  def edit
    if @temp_broker.temp_licenses.count==0
      @temp_broker.build_licenses
    end 
  end
  def update
    if params[:prev]
      
    end
  end
  def show
    @broker=Broker.find(@temp_broker.broker_id)
    @licenses=@broker.licenses
    @temp_licenses=@temp_broker.temp_licenses
  end
  private
  
  def set_temp_broker
    @temp_broker=TempBroker.find(params[:id])
  end
end
