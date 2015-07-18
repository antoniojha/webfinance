class User::SessionsController < User::AuthenticatedController
  skip_before_action :redirect_to_complete_user_profile
  skip_before_action :redirect_to_user_setup
  skip_before_action :authorize_user_login
  skip_before_action :remember_location_user, only:[:new]
  def new
    # serves as blank user object for @user.error.
    @user=User.new
  end

  def password_prompt
    
  end
  def edit
    if params[:id]
      @user=User.find_by(id: params[:id])
      @email=@user.email
    end  
  end
  def update
    @user=User.find_by(id: params[:id])
    @user.send_new_password
    if @user.save
      redirect_to user_login_url, notice: "New Password has been sent to #{@user.email}."
    else
      render "edit"
    end
  end
  def create

    name_or_email=params[:session][:name_or_email].downcase
    user=User.find_by(username: name_or_email) || User.find_by(email: name_or_email)

    respond_to do |format|
      if user && user.has_password?(params[:session][:password])
        user_log_in(user)
        params[:session][:remember]=='1' ? user_remember(user) : user_forget(user)
        format.html { friendly_redirect(user)}
        #  resend email confirmation with a new token if user try to sign in without first authenticating email during sign up
        #     user.send_email_confirmation
      else
        @user=User.new # serves as a dummy object variable for @user.errors so it won't throw any error
        flash.now[:danger]="Invalid username or email/password combination"
        format.html {  render 'new'}
      end
    end
  end

  def destroy
    user_log_out if user_logged_in?
    redirect_to user_login_url, notice: "Logged Out"
  end


end
