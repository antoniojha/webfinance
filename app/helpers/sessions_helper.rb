module SessionsHelper
  def personal_profile?(user)
    if current_user.id==user.id
      return true
    else
      return false
    end
    
  end
  def user_profile_completed?
    user=current_user
    if user.username && user.email && (user.email_authen==true)
      return true
    else
      false
    end
  end
  def redirect_to_complete_user_profile
    user=current_user
    unless user_profile_completed? 
      redirect_to edit_user_url(user), notice: "Please complete your profile (username and email) first."
    end
  end
  def broker_profile_completed?
    broker=current_broker
    if broker.username && broker.email && (broker.email_authen==true)
      return true
    else
      false
    end
  end
  def redirect_to_complete_broker_profile
 
    broker=current_broker
    unless broker_profile_completed? 
      redirect_to edit_broker_url(broker), notice: "Please complete your profile (username and email) first."
    end
  end  
  def remember_broker(broker_id)
    session[:broker_id_schedule]=broker_id.to_i
  end
  def schedule_broker
    if session[:broker_id_schedule]
      if @schedule_broker.nil?
        @schedule_broker=Broker.find_by(id:session[:broker_id_schedule])
      else
        @schedule_broker
      end
    end
  end
  def broker_log_in(broker)
    session[:broker_id]=broker.id
    
  end
  def user_log_in(user)
    session[:user_id]=user.id
  end
  def user_remember(user) # generate and saves auth_token_digest in user
    user.remember
    cookies.permanent.signed[:user_id]=user.id
    cookies.permanent.signed[:auth_token]=user.auth_token
  end
  def current_broker
    if session[:broker_id]
      if @current_broker.nil?
        @current_broker=Broker.find_by(id:session[:broker_id].to_i)
      else
        @current_broker
      end
    end
  end
  def current_user
    if session[:user_id]
      if @current_user.nil?
        @current_user=User.find_by(id:session[:user_id])
      else
        @current_user
      end
    # or replace above with @current_user||=User.find_by(id:session[:user_id])
    elsif cookies.signed[:user_id]
      user=User.find_by(id:cookies.signed[:user_id])
      if user && user.authenticated?(cookies.signed[:auth_token])
        log_in user
        @current_user=user 
      end
    end
  end
  def current_user?(user)
    user==current_user ? true : false
  end
  def broker_logged_in?
    !(current_broker.nil?)
  end
  def user_logged_in?
    !(current_user.nil?)
  end
  def user_log_out
    # this order is very importatn first delete cookies and then session. Otherwise current_user would be called and session[:user_id] would be restored. 
    user_forget(current_user)
    session[:user_id]=nil
    session[:return_to]=nil
    session[:broker_id_schedule]=nil
    @current_user=nil
  end
  def broker_log_out
    broker_forget(current_broker)
    session[:broker_id]=nil
    session[:return_to]=nil
    @current_broker=nil    
  end
  def user_forget(user)
    if user_logged_in?
      user.forget
    end
    cookies.delete(:user_id)
    cookies.delete(:auth_token)
  end
  def broker_forget(broker)
    if broker_logged_in?
      broker.forget
    end
    cookies.delete(:broker_id)
    cookies.delete(:auth_token)
  end
  def friendly_redirect(default, notice=nil)
    redirect_to (session[:return_to] || default), notice:notice 
    session[:return_to]=nil
  end
  def remember_desired_location
    session[:return_to]=request.fullpath
  end
  def redirect_to_setup
    unless current_user.setup_completed?
      redirect_to edit_setup_path(current_user)
    end
  end
end
