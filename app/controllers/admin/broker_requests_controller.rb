class Admin::BrokerRequestsController < Admin::AuthenticatedController
  before_action :set_request, only: [:show,:edit, :update]
  def index
    if params[:page]
      @page=params[:page]
    else
      @page="pending_application"
    end
    if @page=="pending_application"
      @requests=BrokerRequest.where(complement:false).where('admin_reply IS ?', nil).order(created_at: :desc)

    elsif @page=="approved_application"
      @requests=BrokerRequest.where(admin_reply:"approve")
    elsif @page=="disapproved_application"
      @requests=BrokerRequest.where(admin_reply:"disapprove")
    end
  end  
  #used for broker to resubmit application for license to be approved. This is going to be primary request and not complementary request.
  def create
  end
  #used for admin to reject application for license and add any comment
  def edit
  end
  def update
    @page=params[:page]
    @requests=BrokerRequest.where(complement:false).where('admin_reply IS ?', nil).order(created_at: :desc)
    if @request.request_type =="create license"
      
      if @request.update(request_param)
        @license=License.find(@request.license_id)
        if params[:broker_request][:admin_reply]=="approve" 
          @license.update_attributes(approved:true)
        end
        redirect_to admin_broker_requests_path, notice:"#{@request.request_type} is #{@request.admin_reply}d"
      else
        render "index"
      end
    elsif @request.request_type=="create account"
      @request.create_application_bool=true
      if @request.update(request_param)
        @broker=Broker.find(@request.broker_id)
        if params[:broker_request][:admin_reply]=="approve"
          @broker.update_attributes(approved:true)   
        end
        redirect_to admin_broker_requests_path, notice:"#{@request.request_type} is #{@request.admin_reply}d"
      else
        render "index"
      end
    end
    
  end
  def show
  end
  private 
  def request_param
    params.require(:broker_request).permit(:admin_reply)
  end
  def set_request

    @request=BrokerRequest.find(params[:id])
  end

end
