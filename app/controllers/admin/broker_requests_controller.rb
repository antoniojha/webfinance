class Admin::BrokerRequestsController < Admin::AuthenticatedController
  before_action :set_request, only: [:show,:edit, :update]
  def index
    if params[:page]
      @page=params[:page]
    else
      @page="pending_application"
    end
    if @page=="pending_application"
      @requests=BrokerRequest.where(complement:false).where('admin_reply IS ? OR admin_reply= ?', nil, "approve").order(created_at: :desc)
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
    @request.admin_reply=params[:status]
    @request.save
    redirect_to admin_broker_requests_path, notice:"#{@request.request_type} is #{@request.admin_reply}d"
  end
  def show
  end
  private 
  
  def set_request
    @request=BrokerRequest.find(params[:id])
  end

end
