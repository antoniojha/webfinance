module SessionsHelper
   

  # all method related to user
  def user_personal_profile?(user)
    if current_user && (current_user.id==user.id)
      return true
    else
      return false
    end 
  end

  def user_profile_completed?
    if user_logged_in?
      user=current_user
      if user.username && user.email && (user.email_authen==true)
        return true
      else
        false
      end
    end
  end
  def redirect_to_complete_user_profile
    if user_logged_in?
      user=current_user
      unless user_profile_completed? 
        redirect_to edit_user_url(user), notice: "Please complete your profile (username and email) first."
      end
    end
  end
  def user_log_in(user)
    if broker_logged_in?
      broker_log_out
    end
    session[:user_id]=user.id
  end
  def user_remember(user) # generate and saves auth_token_digest in user
    user.remember
    cookies.permanent.signed[:user_id]=user.id
    cookies.permanent.signed[:auth_token]=user.auth_token
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

  def user_forget(user)
    if user_logged_in?
      user.forget
    end
    cookies.delete(:user_id)
    cookies.delete(:auth_token)
  end

  def friendly_redirect(default, notice=nil)
    redirect_to (session[:return_to] || default), notice:notice 
    session[:return_to]=nil
  end
  def remember_desired_location
    session[:return_to]=request.fullpath
  end
  def redirect_to_user_setup
    if current_user
      unless current_user.setup_completed?
        redirect_to edit_setup_path(current_user)
      end
    end
  end

  # all methods related to broker

  def current_broker
    if session[:broker_id]
      if @current_broker.nil?
        @current_broker=Broker.find_by(id:session[:broker_id])
      else
        @current_broker
      end
    elsif cookies.signed[:broker_id]
      broker=Broker.find_by(id:cookies.signed[:broker_id])
      if broker && broker.authenticated?(cookies.signed[:auth_token])
        log_in broker
        @current_broker=broker 
      end
    end
  end
  def broker_personal_profile?(broker)
    if current_broker
      if current_broker.id==broker.id
        return true
      else
        return false
      end 
    end
  end

  def remember(member)
    #member can be either a User or Broker
    
    cookies.permanent.signed[:auth_token]=member.remember_token  
    if (member.class.to_s=="Broker")
      cookies.permanent.signed[:broker_id]=member.id 
    elsif (member.class.to_s=="User")
      cookies.permanent.signed[:user_id]=member.id
    end
  end
  def forget(member)
    #member can be either a User or Broker
    if (member.class.to_s=="Broker")
      if broker_logged_in?
        member.forget_token
      end      
      cookies.delete(:broker_id)
    elsif (member.class.to_s=="User")
      if user_logged_in?
        member.forget_token
      end   
      cookies.delete(:user_id)
    end
    
    cookies.delete(:auth_token)    
  end

  def log_in(member)
    if (member.class.to_s=="Broker")
      if user_logged_in?
        log_out(current_user)
      end 
      session[:broker_id]=member.id
    elsif (member.class.to_s=="User")
      if broker_logged_in?
        log_out(current_broker)
      end 
      session[:user_id]=member.id
    end  
  end
  def log_out(member)
    forget(member)
    if (member.class.to_s=="Broker")    
      session[:broker_id]=nil
      session[:return_to]=nil
      cookies.delete(:broker_id)
      cookies.delete(:auth_token)
      @current_broker=nil    
    elsif (member.class.to_s=="User")
      session[:user_id]=nil
      session[:return_to]=nil
      cookies.delete(:user_id)
      cookies.delete(:auth_token)
      @current_user=nil          
    end
  end  
  def broker_logged_in?
    !(current_broker.nil?)
  end


end
