class EmailConfirmationController < ApplicationController
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
        @user.email_authen=true
        if @user.save
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