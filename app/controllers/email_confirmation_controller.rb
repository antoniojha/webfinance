class EmailConfirmationController < User::AuthenticatedController
  skip_before_action :authorize_user_login, only: [:new,:edit]
  def new    
    @user=User.find_by_id(params[:user_id])
  end
  def edit
    @user=User.find_by_email_confirmation_token(params[:id])
    if @user and @user.email_authen   
      user_log_in(@user)
      redirect_to @user, notice: "Email already authenticated!"
    else
      if(!@user)
        redirect_to user_login_url, alert: "Email authentication didn't go through, try again!"
      else
        if @user.update_attributes(:email_authen=> true)
          user_log_in(@user)
          redirect_to @user, notice: "Email is now authenticated!"
        else
          flash[:notice]="There is an error during the process, please try again later."
        end  
      end   
    end   
  end
end