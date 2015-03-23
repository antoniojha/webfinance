class BrokersController < Broker::AuthenticatedController
  
  skip_before_action :authorize_broker_login, only:[:show,:index]
  before_action :set_broker, only:[:show,:edit,:update,:edit2]
  before_action :direct_to_user_edit, only:[:index]
  

  #edit form for individual registered broker  
  def edit
    @temp_broker=@broker.temp_brokers.find_by(edit_type:1)

  end
  def edit2
    
  end

  def update
 
    keys=%w[first_name last_name institution_name identification license_type]
    keys2=%w[license_type license_number picture]
    params["broker"].each do |key, value|
      if keys.include?(key)
        @broker.send("#{key}=", value)
      end

    end

    attributes_changed=@broker.changed

    if params[:edit1]
      if attributes_changed.include?("first_name") || attributes_changed.include?("last_name")
       @temp_broker=@broker.temp_brokers.new(broker_params_temp)
       @temp_broker.edit_type=1
        unless attributes_changed.include?("identification_file_name")
          # if first name or last name is changed, force user to input a new id field
          @temp_broker.custom_validates=true
        else
          @temp_broker.custom_validates=false
        end
        if @temp_broker.save
          redirect_to @temp_broker, notice: "The request to change your profile has been sent"
        else
          render "edit"
        end
      else
        if @broker.update(broker_params)
          redirect_to @broker
        else
          render "edit"
        end
      end     

    elsif params[:edit2]
      @temp_broker=@broker.temp_brokers.new(broker_params_temp)
      @temp_broker.edit_type=2
      @temp_broker.save

      dup_temp_licenses(@broker,@temp_broker)
      swap_license(@broker,@temp_broker)
     
      if @broker.update(broker_params)
        @broker.next_step_edit
        redirect_to @temp_broker
      #  redirect_to edit2_broker_path(@broker)
      else
        render "edit2"
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
        state=@background.state
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
  def direct_to_user_edit
    if user_logged_in?
        # force user to enter their address, name and phone number before conducting a broker search
      remember_desired_location
      first_name=user.first_name
      last_name=user.last_name
      street=user.street
      city=user.city
      state=user.state
      phone_number=user.phone_number
      unless first_name && last_name && street && city && state && phone_number
        redirect_to edit_user_path(user), notice: "Please fill in your name, address and phone number before broker search."
      end
    end
  end

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
