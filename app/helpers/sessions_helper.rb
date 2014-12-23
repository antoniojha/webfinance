module SessionsHelper
  def log_in(user)
    session[:user_id]=user.id
  end
  def remember(user)
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
  def logged_in?
    !(current_user.nil?)
  end
  def log_out
    # this order is very importatn first delete cookies and then session. Otherwise current_user would be called and session[:user_id] would be restored. 
    forget(current_user)
    session[:user_id]=nil
    session[:return_to]=nil
    @current_user=nil
  end
  def forget(user)
   if logged_in?
      user.forget
    end
    cookies.delete(:user_id)
    cookies.delete(:auth_token)
  end
  def friendly_redirect(default)
    redirect_to (session[:return_to] || default) 
    session[:return_to]=nil
  end
  def remember_desired_location
    session[:return_to]=request.fullpath
  end
end
