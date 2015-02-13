class BrokersController < ApplicationController
  include BrokersHelper
  skip_before_action :authorize_login, only: [:new,:edit, :new2,:create,:update,:finish,:close_finish, :index]
  before_action :set_broker, only:[:show, :edit, :update,:new2]
  skip_before_action :delete_temp_broker, only: [:new,:edit,:update,:create,:new2]  
 # before_action :authorize_status_login
 # skip_before_action :authorize_status_login, only:[:status_lookup]
 # before_action :prevent_resubmit, only:[:edit, :update]
  def new
    @broker=Broker.new
  end
  def edit
    

  end
  def prevent_resubmit
    broker=Broker.find(params[:id])
    if broker.submitted==true
      flash[:danger]="Form already submitted"
      redirect_to new_status_session_url
    end
  end
  def authorize_status_login
    
    unless logged_in? 
      flash[:danger]="Please login"
      redirect_to new_status_session_url
    end
  end

  def new2
    if @broker.licenses.count==0
      @broker.build_licenses
    end
  end
  def show
  end
  def finish
    @broker=Broker.find(params[:id])
    @confirmation_number=session[:confirmation]
  end
  def close_finish
    session[:confirmation]=nil
    redirect_to home_url, notice: "Page closed."
  end
  def index
    if params[:id]
      @broker_search=BrokerSearch.find(params[:id])
      @brokers=@broker_search.brokers
      @brokers=@brokers.paginate(:page => params[:page])
    else
      @brokers=Broker.all.paginate(:page => params[:page])
      @broker_search=BrokerSearch.new
    end
    
  end

  def create   
    @broker=Broker.new(broker_params)

    if @broker.save
      cookies[:temp_broker_id]={value:@broker.id, expires:30.minutes.from_now.utc}
      redirect_to broker_new2_url(id:@broker)
    else
      render "new"
    end
  end
  def update
    if params[:broker_new_next]
      if @broker.update(broker_params)
        redirect_to broker_new2_url(id:@broker)
      else
        render "new"
      end    
    end
    if params[:prev]
      redirect_to edit_broker_url(@broker)
    end
    if params[:submit]
      
      if @broker.update(broker_params)
        confirmation_number=@broker.submit
        session[:confirmation]=confirmation_number
        forget_temp_broker # this prevents broker from getting deleted when user visit other pages
        redirect_to broker_finish_path(id:@broker)
      else     
        render "new2"
      end
    end    
  end
  def review_index
  #  @broker=Broker.all.where(approved:false)
  end

  private
    def set_broker
      @broker=Broker.find(params[:id])
    end
    def broker_params       
      params.require(:broker).permit(:first_name, :last_name, :institution_name, :street, :city, :state,{:license_type => []}, :phone_work_1,:phone_work_2,:phone_work_3,:work_ext,:phone_cell_1,:phone_cell_2,:phone_cell_3, :email,:web,:username, :password, :password_confirmation,licenses_attributes:[:picture,:license_number,:license_type, :_destroy,:id])
    end
end
