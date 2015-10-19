class BrokersController < Broker::AuthenticatedController
  skip_before_action :redirect_to_broker_setup, only:[:index]
  skip_before_action :authorize_broker_login, only:[:show,:index,:new,:create]
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
    if @page=="license_edit"
      set_licenses
    end
  end

  def update

    if params[:send_validation]
      @broker.validate_email_bool=true
      @broker.evaluate_and_reset_email_authen(params[:broker][:email])
    end
    if params[:validate_email]
      broker=Broker.find_by_email_confirmation_token(params[:broker][:validation_code])
      if broker ==@broker
        @broker.update_attribute(:email_authen, true)
      end
    end
    respond_to do |format|
      if params[:edit_products]
        @broker.products_bool=true
      end
      if params[:delete_picture]
        @broker.image=nil
        @broker.image_cropped=nil
        @broker.remove_image!
        if @broker.save
          format.html { redirect_to @broker,notice:'Your profile was successfully updated.'}
        else
          format.html{render "show"}
        end
      else  
        if @broker.change_experience?(broker_params)
          change_experience=true
        end
        if @broker.update(broker_params)

          if params[:broker][:image].blank?     
            if @broker.cropping?
              @broker.update_attributes(image_cropped:false)
              @broker.crop_image
            end     
          end
          if @broker.validate_email_bool && (@broker.email_authen!=true)
              @broker.send_email_confirmation
          end   
          #update current experience based on broker's title, company name, and location
          if change_experience
            @broker.set_assoc_experience
          end
          set_licenses
          format.js{}
          format.html { redirect_to @broker,notice:'Broker was successfully updated.'}
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
    
    @licenses=@broker.setup_broker.licenses
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

  private
  def set_licenses
    @licenses=@broker.setup_broker.licenses
    @license=License.new
    @financial_product=FinancialProduct.new
  end
  def set_broker
    @broker=Broker.find(params[:id])
  end

  def broker_params       
    params.require(:broker).permit(:first_name, :last_name, :street, :city, :state, :email,:username, :password, :password_confirmation, :crop_x,:crop_y,:crop_w,:crop_h, :skills, :ad_statement, :phone_number_work, :phone_number_cell, :web,{:product_ids => []},:image, :company_location, :company_name, :title)

  end
end
