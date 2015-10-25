class LicensesController < ApplicationController
  before_action :set_broker, only:[:create,:destroy]
  before_action :set_license, only:[:destroy]
  def create
    @license=@broker.setup_broker.licenses.build(license_params)
    respond_to do |format|
      if @license.save
        if params[:registration]
          # broker_request gets created at the submission during registration
          format.html{redirect_to edit_setup_broker_path(@broker)}
        else
          @broker.broker_requests.create(request_type:"create license", license_id:@license.id,complement:false)
          format.html{redirect_to edit_broker_path(id:@broker.id, page:"license_edit")}
          format.js{}
        end
      else
        if params[:registration]
          @setup_broker=@broker.setup_broker
          @broker.add_or_remove_license
          @licenses=@setup_broker.licenses
          format.html{render "setup_brokers/edit"}
        else
          @error=true
          @page="license_edit"
          format.html{render "brokers/edit"}
          format.js{}
        end
      end
    end
  end
  def destroy
    unless params[:registration]
      @license.destroy
      @license.broker_request.destroy
      redirect_to edit_broker_path(id:@broker.id, page:"license_edit"), notice:"License application successfully removed"
    else
      #only remove the license_image and not the license
      @license.destroy
      redirect_to edit_setup_broker_path(@broker)
    end
    
  end
  private
  def set_broker
    @broker=Broker.find(params[:broker_id])
  end
  def set_license
    @license=License.find(params[:id])
  end
  def license_params
    params.require(:license).permit(:license_image, :expiration_date, :license_number,:license_type)
  end
end
