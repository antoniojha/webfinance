class LicensesController < ApplicationController
  before_action :set_broker, only:[:create,:destroy]
  before_action :set_license, only:[:destroy]
  def create
    @license=@broker.setup_broker.licenses.build(license_params)
    @license.license_type_display="test"
    if @license.save
      @broker.broker_requests.create(request_type:"create license", license_id:@license.id,complement:false)
      redirect_to broker_licenses_path(@broker)
    else
      
      render "brokers/licenses"
    end
  end
  def destroy

    @license.destroy
    @license.broker_request.destroy
    redirect_to broker_licenses_path(@broker), notice:"License application successfully removed"
  end
  private
  def set_broker
    @broker=Broker.find(params[:broker_id])
  end
  def set_license
    @license=License.find(params[:id])
  end
  def license_params
    params.require(:license).permit(:picture, :license_number,:license_type)
  end
end
