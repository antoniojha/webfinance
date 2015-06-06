class LicensesController < ApplicationController
  before_action :set_broker, only:[:create,:delete]
  def create
    @license=@broker.setup_broker.licenses.build(license_params)
    if @license.save
      redirect_to broker_licenses_path(@broker)
    else
      render "brokers/licenses"
    end
  end
  def destroy
    
  end
  private
  def set_broker
    @broker=Broker.find(params[:broker_id])
  end
  def license_params
    params.require(:license).permit(:picture, :license_number,:license_type)
  end
end
