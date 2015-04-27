class User::SessionsController < User::AuthenticatedController
  skip_before_action :redirect_to_complete_user_profile
  skip_before_action :authorize_user_login, only: [:new, :create,:destroy]
  skip_before_action :remember_location_user, only:[:new]
  def new
  end

  def create
   # raise env['omniauth.auth'].to_yaml
   
    if env['omniauth.auth']
    user=User.from_omniauth(env['omniauth.auth'])
    user_log_in(user)
    friendly_redirect user, notice: "Signed in."
    else
      name_or_email=params[:session][:name_or_email].downcase
      user=User.find_by(username: name_or_email) || User.find_by(email: name_or_email)

      respond_to do |format|
        if user && user.has_password?(params[:session][:password])
            user_log_in(user)
            params[:session][:remember]=='1' ? user_remember(user) : user_forget(user)
            format.html { friendly_redirect user}
            #  resend email confirmation with a new token if user try to sign in without first authenticating email during sign up
       #     user.send_email_confirmation
        else
          flash.now[:danger]="Invalid user/password combination"
          format.html {  render 'new'}
        end
      end
    end
  end

  def destroy
    user_log_out if user_logged_in?
    redirect_to user_login_url, notice: "Logged Out"
  end


end
