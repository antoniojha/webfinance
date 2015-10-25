class BrokersController < Broker::AuthenticatedController
  skip_before_action :redirect_to_broker_setup, only:[:index]
  skip_before_action :authorize_broker_login, only:[:show,:index,:new,:create,:home]
  before_action :set_broker, only:[:show,:edit,:remove,:home,:update,:destroy,:products,:licenses]
  def new
    @broker=Broker.new
  end
  def create
    
    @broker=Broker.new(broker_params)
    @broker.non_signup_provider_bool=true
    if @broker.save
      session[:broker_id]=@broker.id
      redirect_to edit_setup_broker_path(@broker)
    else
      render "brokers/new"
    end
  end
  def home
    unless params[:interest]
      @interest="protection"
    else
      @interest=params[:interest]
    end    
    render :template=>"shared/home"
  end
  def edit
    @page=params[:page]
    if @page.nil?
      @page="form_edit"
    end
  end

  def update
    if params[:send_validation]
      @broker.send_email_validation_bool=true
      @validate_email_error=true  
    elsif params[:validate_email]
      @broker.validate_email_bool=true 
    else
      @broker.basic_info_bool=true
    end
    #@page indicates which of the view it will show when rendering error.
    @page="form_edit" 
    #set prev_email for validating email purpose
    @broker.prev_email=@broker.email    
  
    respond_to do |format|    
      if params[:delete_picture]
        @broker.image=nil
        @broker.image_cropped=nil
        @broker.remove_image!
        if @broker.save
          format.html { redirect_to @broker,notice:'Your profile was successfully updated.'}
        else
          format.html{render "show"}
        end
      elsif params[:validate_email]
        if @broker.confirm_email?(params[:broker][:validation_code])   
          format.html{redirect_to edit_broker_path(@broker)}
        else
          format.html{render "edit"}
        end
      else  
        # this has to be before update action to check if there is a change in value of title, company_name, company_location 
        if @broker.change_experience?(broker_params)
          change_experience_bool=true
        end      
        
        if @broker.update(broker_params)   
          if params[:send_validation]
            if @broker.evaluate_and_reset_email_authen(@broker.prev_email)          
              @broker.send_email_confirmation
              notice="Validation code has been sent to your email."
            end
          end
          if @broker.cropping?
            @broker.update_attributes(image_cropped:false)
            @broker.crop_image
          end     
          #update current experience based on broker's title, company name, and location
          if change_experience_bool
            @broker.set_assoc_experience
          end
          format.js{}
          if params[:setting]
            unless params[:send_validation]
              format.html { redirect_to edit_broker_path(@broker),notice:'Your profile was successfully updated.'}
            else
              format.html { redirect_to edit_broker_path(@broker), notice:notice}  
            end
          else
            format.html { redirect_to @broker,notice:'Your profile was successfully updated.'}
          end
        else
          @error=true
          format.js{}
          format.html { render action: 'edit' }      
        end  
      end
    end
  end
  #display individual broker
  def show
    unless params[:key]
      @uploader = @broker.image
      @uploader.success_action_redirect = broker_url(@broker)
    else      
      #saves broker association with image after redirect from aws s3 after direct image upload
      @crop=true
      @broker.key=params[:key]
      @broker.save_and_process_image
    end
    respond_to do |format|
      format.html{}
      format.js
    end    
  end

  #display broker search form
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
  def destroy
    if @broker.has_password?(params[:broker][:password])
      @broker.destroy
      redirect_to broker_signup_path, notice:"Your profile has been removed."
    else
      @page="form_remove"
      @broker.errors.add(:addition_error_msg,"Password doesn't not match")
      render "brokers/edit"
    end
  end
  private
  def set_broker
    @broker=Broker.find(params[:id])
  end

  def broker_params       
    params.require(:broker).permit(:first_name, :last_name, :street, :city, :state, :email,:username, :password, :password_confirmation, :crop_x,:crop_y,:crop_w,:crop_h, :skills, :ad_statement, :phone_number_work, :phone_number_cell, :web,{:product_ids => []},:image, :company_location, :company_name, :title)

  end
end
