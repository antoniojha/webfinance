class Broker::SessionsController < Broker::AuthenticatedController
  skip_before_action :redirect_to_complete_broker_profile
  skip_before_action :redirect_to_broker_setup
  skip_before_action :authorize_broker_login
  skip_before_action :remember_location_broker, only:[:new]
  before_action :set_broker, only:[:password_lookup_2]

  def new
    # serves as blank broker object for @broker.error.
    @broker=Broker.new
  end
  def password_prompt_1
      
  end  
  def password_lookup_2
    
  end
  # the link user click on to redirect to enter new password
  def enter_new_password_3
    @broker = Broker.find_by_password_confirmation_token!(params[:id])
  end
  # used to send reset password message
  def update
    if params[:name]=="send_reset_password"
      @broker=Broker.find(params[:id])  
      @broker.send_reset_password_msg
      flash.now[:info]="Password reset email has been sent!"
      render "password_lookup_2"
    elsif params[:name]=="reset_password"
      
      @broker=Broker.find_by_password_confirmation_token!(params[:id])
      @broker.non_signup_provider_bool=true
      if @broker.password_reset_send_at < 2.hours.ago
        flash[:danger]="Password reset has expired."
        redirect_to broker_password_lookup_path(@broker)
      elsif @broker.update(broker_params)
        redirect_to broker_login_path, :notice => "Password has been reset."
      else
        render :enter_new_password_3
      end       
    end
    
  end
  def search
    name_or_email=params[:session][:name_or_email].downcase
    @broker=Broker.find_by(username: name_or_email) || Broker.find_by(email: name_or_email)  
    
    if @broker
      redirect_to broker_password_lookup_path(id:@broker.id)
    else    
      flash.now[:danger]="Username/email can't be found!"
      render "password_prompt_1"
    end
  end  
  def create
      
    name_or_email=params[:session][:name_or_email].downcase
    broker=Broker.find_by(username: name_or_email) || Broker.find_by(email: name_or_email)
    respond_to do |format|
      if broker && broker.has_password?(params[:session][:password])
        log_in(broker)
        if broker.setup_completed? 
          params[:session][:remember]=='1' ? remember(broker) : forget(broker)
          format.html{ friendly_redirect broker}
        else
          format.html{ redirect_to edit_setup_broker_path(broker)}
        end
      else
        @broker=Broker.new
        flash.now[:danger]="Invalid username or email/password combination"
        format.html {  render 'new'}
      end
    end
  end
  def destroy
    log_out(current_broker) if broker_logged_in?
    redirect_to broker_login_url, notice: "Logged Out"
  end
  private
  def set_broker
    @broker=Broker.find(params[:id])  
  end
  def broker_params
    params.require(:broker).permit(:password,:password_confirmation)
  end
end