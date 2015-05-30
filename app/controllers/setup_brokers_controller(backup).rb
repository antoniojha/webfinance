class SetupBrokersBackupController < ApplicationController
  before_action :set_broker, only:[:edit,:update]
  def create 
  #  raise "error"
    # this breaks the MVC model but is used to create licenses during broker setup. A dummy variable @setup_broker is used to generate forms that will have the accepted nested attributes. However, no SetupBroker object is created or store in database at all.
   # raise "error"
    @broker=Broker.find(params[:setup_broker][:broker_id])

      @setup_broker=@broker.build_setup_broker(license_params)
      if @setup_broker.save
        @broker.next_step
        @broker.save
        redirect_to edit_setup_broker_path(@broker)
      else 
        render "edit"
      end
    
  end
  def edit

    if @broker.step=="license_info_3"
      unless @broker.setup_broker
        @setup_broker=@broker.build_setup_broker
        @broker.license_type.each do |l|        
          @setup_broker.licenses.build(license_type:l)        
        end
      else
        @setup_broker=@broker.setup_broker
      end
    end

  end
  def update   
 #   raise "error"
    if params[:back]
      if @broker.update(broker_params)
        @broker.prev_step
        @broker.save
        redirect_to edit_setup_broker_path(@broker)
      else
        render "edit"
      end  
    elsif params[:back_from_pg3]
        @broker.prev_step
        @broker.save  
        redirect_to edit_setup_broker_path(@broker)
    else     
      @broker.setup_bool=true
      if (@broker.step=="license_2")
        @broker.licensetype_bool=true
      end

      if params[:next_from_pg3]
        @setup_broker=@broker.build_setup_broker(license_params)
        if @setup_broker.save
          @broker.next_step
          @broker.save
          redirect_to edit_setup_broker_path(@broker)
        else 
          render "edit"
        end
      else
        if @broker.update(broker_params)
          if params[:next_from_pg2]
            add_or_remove_license
          end
          @broker.next_step
          @broker.save
          if params[:submit]
            @broker.update_attribute(:setup_completed?, true)
          end
          unless @broker.setup_completed?
            redirect_to edit_setup_broker_path(@broker)
          else
            redirect_to edit_broker_path(@broker)
          end
        else
       #   Rails.logger.info(@user.errors.inspect) 
          render "edit"
        end
      end
    end  
  end
  def download
    @license= License.find(params[:id])
    send_file @license.picture.path,
    :filename => @license.picture_file_name,
    :type => @license.picture_content_type,
    :disposition => 'attachment'
  end
  private
  def set_broker
    @broker=Broker.find(params[:id])
  end
  def broker_params
    params.require(:broker).permit(:first_name, :last_name, :company_name,:company_location, :email, :title,{:license_type => []})
  end

  def license_params
    params.require(:setup_broker).permit( licenses_attributes:[:license_type,:license_number,:picture])
  end
  def ex_license_types(setup_broker)
    array=[]
    setup_broker.licenses.each do |f|
      array<< f.license_type
    end
    return array
  end
  def add_or_remove_license
    
    @setup_broker=@broker.setup_broker
    ex_license_types=ex_license_types(@setup_broker)
    # create new license objects to be filled out in user checks a new license type in page 2
    @broker.license_type.each do |l|
      unless ex_license_types.include?(l)
        @setup_broker.licenses.build(license_type:l)
      end
    end
    #delete existing license object if user unchecks an existing license type in page 2
    ex_license_types.each do |l|
      unless @broker.license_type.include?(l)
       @setup_broker.licenses.where(license_type:l).destroy
      end
    end
  end
end
