class Register::BrokersController < ApplicationController
 # prepend_view_path 'app/views/register'
 
  before_action :authorize_status_login
  # broker needs authorization to complete or view application each time
  skip_before_action :authorize_status_login, only:[:new,:create,:status, :status_lookup]
  before_action :prevent_resubmit, only:[:edit, :update]
  before_action :set_broker, only:[:edit, :update,:status,:finish]
  def new
    @broker=Broker.new
  end

  def edit
    if @broker.licenses.count==0
      @broker.build_licenses
    end 
  end
  def create   
      @broker=Broker.new(broker_params)
      respond_to do |format|
        if @broker.save     
          broker_log_in(@broker)
          format.html{redirect_to broker_url(@broker)}
        else
          format.html{render "new"}
        end 
      end
  end

  def update  
    if params[:next]
      @broker.next_step
      unless (@broker.register_current_step=="final_summary4")
        if @broker.update(broker_params)
          redirect_to edit_register_broker_url(@broker)
        else
          @broker.prev_step
          render "register/brokers/edit"
        end    
      else
        @broker.save # save current step
        redirect_to edit_register_broker_url(@broker)
      end
    elsif params[:add_appointment]
      @product=Product.find(params[:product_id])
      begin
        @broker.appoint(@product)
      rescue ActiveRecord::RecordNotUnique
        @error="Record already exists"
      end
      respond_to do |format|
        format.js{}
      end
    elsif params[:prev]
      @broker.prev_step
      @broker.save
      redirect_to edit_register_broker_url(@broker)
    elsif params[:submit]
      @broker.submit
      redirect_to register_broker_finish_url(id:@broker)
    end    
  end  

  def remove_appointment
    product=Product.find(params[:product_id])
    @broker=Broker.find(params[:broker_id])
    @broker.unappoint(product)
    respond_to do |format|
      format.js{}
    end
  end
  def show
  end
  def product_lookup
    @firm=Firm.find(params[:firm_id])
    @broker=Broker.find(params[:broker_id])
    respond_to do |format|
      format.js{}
    end
  end


  def prevent_resubmit
    broker=Broker.find(params[:id])
    if broker.submitted==true
      flash[:danger]="Form already submitted"
      redirect_to register_broker_status_url(id:broker.id)
    end
  end
  # authorize_status_login will implement first to force broker to sign in to continue their application or view status
  # prevent_resubmit will then implement in case broker while signed in tried to access the application edit page they have submitted
  def authorize_status_login 
    unless broker_logged_in? 
      flash[:danger]="Please login"
      redirect_to new_status_session_url
    end
  end
  def status  
  end
  def finish
  end
  def close_finish
    broker_log_out
    redirect_to new_status_session_url, notice: "Page closed."
  end

   private
    def set_broker
      @broker=Broker.find(params[:id])
    end
    def broker_params       
      params.require(:broker).permit(:first_name, :last_name, :institution_name, :identification, :street, :city, :state,{:license_type => []}, :phone_work_1,:phone_work_2,:phone_work_3,:work_ext,:phone_cell_1,:phone_cell_2,:phone_cell_3, :email,:web,:username, :password, :password_confirmation,:firm_id,licenses_attributes:[:picture,:license_number,:license_type, {:states=>[]}, :_destroy,:id])
    end


end