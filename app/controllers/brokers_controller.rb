class BrokersController < Broker::AuthenticatedController
  skip_before_action :redirect_to_broker_setup, only:[:index]
  skip_before_action :redirect_to_complete_broker_profile, only:[:new,:edit,:remove,:create,:update,:destroy,:index]
  skip_before_action :authorize_broker_login, only:[:show,:index,:new,:create]
  before_action :set_broker, only:[:show,:edit,:remove,:home,:update,:destroy,:products,:licenses]
  def new
    @broker=Broker.new
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

  end
  def remove
    
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
        if @broker.update(broker_params)

          if params[:broker][:image].blank?     
            if @broker.cropping?
          #    @broker.image.recreate_versions!
              @broker.update_attributes(image_cropped:false)
              @broker.crop_image
          #    @broker.reload
              
          #    @broker.remote_image_url = @broker.image.direct_fog_url(with_path: true)
          #    @broker.save!
          #    @broker.image.recreate_versions!

            end
            if @broker.validate_email_bool && (@broker.email_authen!=true)
              @broker.send_email_confirmation
            end

            format.html { redirect_to @broker,notice:'Broker was successfully updated.'}
          else
            format.html{
              redirect_to :controller => 'brokers', :action => 'show', :id => @broker.id}
          end
        else
          format.html { render action: 'edit' }
          format.js{}
          format.json { render json: @broker.errors, status: :unprocessable_entity }
        end  
      end
    end
  end
  #display individual broker
  def show
    unless params[:key]
      @uploader = Broker.new.image
      @uploader.success_action_redirect = broker_url(@broker)
    else      
      @crop=true
      @broker.key=params[:key]
      @broker.save
    end
    @edit=params[:edit]
    @education=Education.new #needed for education_add partial template
    @experience=Experience.new #needed for experience_add partial template
    @financial_product =FinancialProduct.new
    @story=FinancialStory.new
    if params[:method]=="edit"
      @edit_story=FinancialStory.find(params[:financial_story_id])
    elsif params[:method]=="delete"
      @delete_story=FinancialStory.find(params[:financial_story_id])
    end
    respond_to do |format|
      format.html{}
      format.js
    end    
  end
  def licenses
    @licenses=@broker.setup_broker.licenses
    @license=License.new
  end
  def products
    
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
  def set_broker
    @broker=Broker.find(params[:id])
  end

  def broker_params       
    params.require(:broker).permit(:first_name, :last_name, :street, :city, :state, :email,:username, :password, :password_confirmation,:picture, :crop_x,:crop_y,:crop_w,:crop_h, :skills, :ad_statement, :phone_number_work, :phone_number_cell, :web,{:product_ids => []},:image)

  end
end
