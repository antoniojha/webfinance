class SessionsController < ApplicationController
  skip_before_action :authorize
  def new
  end

  def create
    #@user2=User.find_by(username: params[:username])
    @user=User.find_by(username: params[:username])
    
    respond_to do |format|
      if @user && @user.authenticate(params[:password])
        if @user.email_authen==true
          session[:auth_token]=@user.auth_token
          session[:user_id]=@user.id
          session[:username]=@user.username
          format.html { redirect_to profile_url(@user.username)}
        else
          #  resend email confirmation with a new token if user try to sign in without first authenticating email during sign up
          session[:user_id]=@user.id
          @user.send_email_confirmation
          format.html { redirect_to confirmation_url}
        end
      else
        flash.now[:notice]="Invalid user/password combination"
        format.html {  render 'new'}
      end
    end
  end

  def destroy
    session[:user_id]=nil
    session[:username]=nil
    redirect_to login_url, notice: "Logged Out"
  end
end
