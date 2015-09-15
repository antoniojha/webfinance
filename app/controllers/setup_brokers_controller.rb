class SetupBrokersController < ApplicationController
  before_action :set_broker, only:[:edit,:update]

  def create 
  #  raise "error"
    # this breaks the MVC model but is used to create licenses during broker setup. A dummy variable @setup_broker is used to generate forms that will have the accepted nested attributes. However, no SetupBroker object is created or store in database at all.
      @broker=Broker.find(params[:setup_broker][:broker_id])
      @setup_broker=@broker.setup_broker
      unless @setup_broker
        if params[:back]
          @broker.prev_step
          @broker.save
          redirect_to edit_setup_broker_path(@broker)
        else
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
  end
  def edit

    if @broker.step=="license_info_4"
      unless @broker.setup_broker
        @setup_broker=@broker.build_setup_broker
        @broker.license_type.each do |l|        
          @licenses=@setup_broker.licenses.build(license_type:l)        
        end    
      else
        @setup_broker=@broker.setup_broker
        @broker.add_or_remove_license
        @licenses=@setup_broker.licenses
      end
    elsif @broker.step=="financial_story_7"
      unless @broker.financial_stories.first
        @financial_story=@broker.financial_stories.build
      end
    end

  end

  def update   

    if params[:back]
      @broker.prev_step
      @broker.save
      redirect_to edit_setup_broker_path(@broker)
    else   
      if params[:validate_email]
        @broker.validate_email_bool=true
      end
      if (@broker.current_field=="basic_info_1")
        
        @broker.basic_info_bool=true
      end
      if @broker.current_field=="id_2"
        @broker.id_image_bool=true
      end
      if (@broker.current_field=="license_3")
        @broker.licensetype_bool=true
      end
      if (@broker.current_field=="license_info_4")
        @broker.licenses_upload_bool=true
      end
      if (@broker.current_field=="vehicle_5")
        @broker.products_bool=true
      end

      if (@broker.current_field=="term_of_use_8")
        @broker.term_of_use_bool=true
      end
      if params[:upload_license]
         @setup_broker=@broker.setup_broker
         if @setup_broker.update(license_params)
         #  @broker.next_step
         #  @broker.save
           redirect_to edit_setup_broker_path(@broker)
          else
           render "setup_brokers/edit"
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
          if params[:next_from_pg3]
            
          #  @broker.add_or_remove_license
          end
          unless params[:send_validation] || params[:validate_email] || params[:upload_id] || params[:upload_license]
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
            redirect_to broker_path(@broker), notice:"Your registration has been submitted and is being reviewed."
          end
        else
          if params[:next_from_pg4]
            @setup_broker=@broker.setup_broker
            @broker.add_or_remove_license
            @licenses=@setup_broker.licenses
          end
       #   @uploader = @broker.id_image
       #   @uploader.success_action_redirect = edit_setup_broker_url(@broker)
          render "edit"
        end
      end
    end 
  end
  def download_driver_license
    @broker=Broker.find(params[:id])
    data = open(@broker.id_image.url) 
    send_data data.read, filename: @broker.id_image.file.filename, type: "application/#{@broker.id_image.file.extension}", disposition: 'inline', stream: 'true', buffer_size: '4096'
  end
  def download_broker_license
    @license= License.find(params[:id])
    data = open(@license.license_image.url) 
    send_data data.read, filename: @license.license_image.file.filename, type: "application/#{@license.license_image.file.extension}", disposition: 'inline', stream: 'true', buffer_size: '4096'
  end
  def remove_id
    @broker=Broker.find(params[:id])
    @broker.remove_id_image!
    @broker.save
    redirect_to edit_setup_broker_url(@broker)
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
    params.require(:broker).permit(:first_name, :last_name, :id_image, :company_name,:company_location, :email, :title,{:license_type => []},{:product_ids => []}, :skills, :ad_statement, :check_term_of_use, financial_stories_attributes:[:id, :product_id,:financial_category,:description, :title])
  end

  def license_params
    params.require(:setup_broker).permit( licenses_attributes:[:license_type,:license_number,:license_image, :expiration_date, :id])
  end


end
