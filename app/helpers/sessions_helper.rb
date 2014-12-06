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
      if user.authenticated?(cookies.signed[:auth_token])
        @current_user=user
        log_in user
      end
    end
      
  end
  def logged_in
    !current_user.nil?
  end
  def log_out
    session[:user_id]=nil
    @current_user=nil
  end
end
