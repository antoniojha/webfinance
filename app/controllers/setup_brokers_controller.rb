class SetupBrokersController < ApplicationController
  before_action :set_broker, only:[:edit,:update]
  def create 
  #  raise "error"
    # this breaks the MVC model but is used to create licenses during broker setup. A dummy variable @setup_broker is used to generate forms that will have the accepted nested attributes. However, no SetupBroker object is created or store in database at all.
      @broker=Broker.find(params[:setup_broker][:broker_id])
      @setup_broker=@broker.setup_broker
      unless @setup_broker

        @setup_broker=@broker.build_setup_broker(license_params)
        if @setup_broker.save
          @broker.next_step
          @broker.save
          redirect_to edit_setup_broker_path(@broker)
        else 
          render "edit"
        end
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
      @broker.prev_step
      @broker.save
      redirect_to edit_setup_broker_path(@broker)
    else    
      if params[:send_validation] || params[:validate_email]
        @broker.validate_email_bool=true

      end
      if (@broker.current_field=="basic_info_1")
        
        @broker.basic_info_bool=true
      end
      if (@broker.current_field=="license_2")
        @broker.licensetype_bool=true
      end
      if (@broker.current_field=="vehicle_4")
        @broker.product_names_bool=true
      end
      if (@broker.current_field=="register_approve_info_6")
        @broker.story_bool=true
      end
      if (@broker.current_field=="term_of_use_7")
        @broker.term_of_use_bool=true
      end
      if params[:next_from_pg3]
         @setup_broker=@broker.setup_broker
         if @setup_broker.update(license_params)
           @broker.next_step
           @broker.save
           redirect_to edit_setup_broker_path(@broker)
          else
            render "edit"
          end
      else
        if @broker.update(broker_params)
          if params[:send_validation]

            @broker.send_email_confirmation
            @broker.evaluate_and_reset_email_authen(params[:broker][:email])
          end
          if params[:validate_email]
          #  raise "#{params[:broker][:validation_code]}"
            broker=Broker.find_by_email_confirmation_token(params[:broker][:validation_code])
            if broker == @broker
              @broker.update_attribute(:email_authen, true)
            end
          end 
          if params[:next_from_pg1]
            
            title=params[:broker][:title]
            company=params[:broker][:company_name]
            location=params[:broker][:company_location]
            @broker.experiences.create(title:title,company:company,location:location,current_experience:true, begin_date: Date.today)
          end
          if params[:next_from_pg2]
            @broker.add_or_remove_license
          end
          unless params[:send_validation] || params[:validate_email]
            @broker.next_step
            @broker.save
          end
          if params[:submit]
            @broker.update_attribute(:setup_completed?, true)
            @broker.broker_requests.create(request_type:"create account",complement:false)
            @broker.setup_broker.licenses.each do |l|
              @broker.broker_requests.create(request_type:"create license", license_id:l.id,complement:true)
            end
          end
          unless @broker.setup_completed?
            redirect_to edit_setup_broker_path(@broker)
          else
            redirect_to broker_path(@broker)
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
    if params[:setup_broker] && params[:setup_broker][:broker_id]
      @broker=Broker.find(params[:setup_broker][:broker_id])
    else
      @broker=Broker.find(params[:id])
    end
  end
  def broker_params
    params.require(:broker).permit(:first_name, :last_name, :company_name,:company_location, :email, :title,{:license_type => []},{:product_names => []}, :skills, :ad_statement, :financial_category, :product_id, :story, :check_term_of_use)
  end

  def license_params
    params.require(:setup_broker).permit( licenses_attributes:[:license_type,:license_number,:picture, :id])
  end


end
