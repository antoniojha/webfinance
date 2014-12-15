class EmailConfirmationController < ApplicationController
  skip_before_action :authorize_login, only: [:new,:edit]
  def new    
    @user=User.find_by_id(params[:user_id])
  end
  def edit
    @user=User.find_by_email_confirmation_token(params[:id])
    if @user and @user.email_authen      
      redirect_to @user, notice: "Email already authenticated!"
    else
      if(!@user)
        redirect_to login_url, alert: "Email authentication didn't go through, try again!"
      else
        if @user.update_attribute(:email_authen, true)
          log_in(@user)
          remember @user
          redirect_to @user, notice: "Email is now authenticated!"
        else
          flash[:notice]="There is an error during the process, please try again later."
        end  
      end   
    end   
  end
end