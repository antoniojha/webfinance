class BrokersController < Broker::AuthenticatedController
  skip_before_action :redirect_to_broker_setup, only:[:new,:edit,:create,:update,:destroy]
  skip_before_action :redirect_to_complete_broker_profile, only:[:new,:edit,:create,:update,:destroy]
  skip_before_action :authorize_broker_login, only:[:show,:index]
  before_action :set_broker, only:[:show,:edit,:update,:edit2]

  #edit form for individual registered broker  
  def edit
    #

  end
  def edit2
    
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
      if @broker.update(broker_params)
        if params[:broker][:picture].blank?
         # if @broker.cropping?
       #     @broker.reprocess_picture
        #  end
          if @broker.validate_email_bool && (@broker.email_authen!=true)
            @broker.send_email_confirmation
          end
          format.html { redirect_to @broker,notice:'Broker was successfully updated.'}
        else
          format.html{render :action=>"crop"}
        end
      else
        format.html { render action: 'edit' }
        format.json { render json: @broker.errors, status: :unprocessable_entity }
      end  
    end
  end
  #display individual broker
  def show
  end
  #display broker search form
  def index
    @user=current_user
    if @user
      @background=@user.backgrounds.last
      if params[:id]
        @broker_search=BrokerSearch.find(params[:id])
        @brokers=@broker_search.brokers
        @brokers=@brokers.paginate(:page => params[:page])  
      else
        state=@user.state
        @brokers=Broker.where("state = ?",state).paginate(:page => params[:page])
        @broker_search=BrokerSearch.new
        @broker_search.state=state
      end 
    else
      @broker_search=BrokerSearch.new
      @brokers=Broker.all.paginate(:page => params[:page])
    end
  end


  private


  def set_broker
    @broker=Broker.find(params[:id])
  end

  def broker_params       
      params.require(:broker).permit(:first_name, :last_name, :institution_name, :identification, :street, :city, :state,{:license_type_edit => []},{:license_type_remove => []}, :phone_work_1,:phone_work_2,:phone_work_3,:work_ext,:phone_cell_1,:phone_cell_2,:phone_cell_3, :email,:web,:username, :password, :password_confirmation,:firm_id,licenses_attributes:[:picture,:license_number,:license_type, {:states=>[]}, :_destroy,:id])

  end
  # all the parameters for the non-license part
  def broker_params_temp
    params.require(:broker).permit(:first_name, :last_name, :institution_name, :identification, :street, :city, :state,{:license_type_edit => []},{:license_type_remove => []}, :phone_work_1,:phone_work_2,:phone_work_3,:work_ext,:phone_cell_1,:phone_cell_2,:phone_cell_3, :email,:web)
  end
  def dup_temp_licenses(broker,temp_broker)
    broker.licenses.each do |l|        temp=temp_broker.temp_licenses.new(license_type:l.license_type,license_number:l.license_number,approved:l.approved)
    temp.picture=l.picture
    temp.save
    end
  end
  def swap_license(broker,temp_broker)
    (broker.licenses).zip(temp_broker.temp_licenses).each do |l,temp_l|
      temp=TempLicense.new(temp_l.attributes)
        
      if (l.license_number==temp_l.license_number) &&(l.states==temp_l.states)
        temp_broker.temp_licenses.destroy_all
        temp_broker.destroy
        broker.custom_validates=true
        #check if attributes has changed
        
      else
        temp_l.license_number=l.license_number
        temp_l.picture=l.picture
        temp_l.states=l.states
             
        l.picture=temp.picture    
        l.license_number=temp.license_number
        l.states=temp.states
        l.save
        temp_l.save
      end

    end
  end

end
