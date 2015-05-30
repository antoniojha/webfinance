class BrokersController < Broker::AuthenticatedController
  skip_before_action :redirect_to_broker_setup, only:[:new,:edit,:create,:update,:destroy]
  skip_before_action :redirect_to_complete_broker_profile, only:[:new,:edit,:create,:update,:destroy]
  skip_before_action :authorize_broker_login, only:[:show,:index]
  before_action :set_broker, only:[:show,:edit,:home,:update,:destroy,:edit2]

  #edit form for individual registered broker  
  def home
    
  end
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
      if params[:delete_picture]
        @broker.picture=nil
        if @broker.save
          format.html { redirect_to @broker,notice:'Your profile was successfully updated.'}
        else
          render "show"
        end
      elsif @broker.update(broker_params)
        if params[:broker][:picture].blank?
          if @broker.cropping?
            @broker.reprocess_picture
          end
          if @broker.validate_email_bool && (@broker.email_authen!=true)
            @broker.send_email_confirmation
          end
          format.html { redirect_to @broker,notice:'Broker was successfully updated.'}
        else
          format.html{
            redirect_to :controller => 'brokers', :action => 'show', :id => @broker.id, :crop => true
          }
        end
      else
        format.html { render action: 'edit' }
        format.json { render json: @broker.errors, status: :unprocessable_entity }
      end  
    end
  end
  #display individual broker
  def show
    @crop=params[:crop]
    if params[:edit]=="about"
      @edit="about"
    elsif params[:edit]=="skills"
      @edit="skills"
    end
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
    params.require(:broker).permit(:first_name, :last_name, :street, :city, :state, :email,:username, :password, :password_confirmation,:picture, :crop_x,:crop_y,:crop_w,:crop_h)

  end
end
