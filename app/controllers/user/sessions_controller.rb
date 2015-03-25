class User::SessionsController < ApplicationController
  skip_before_action :authorize_user_login, only: [:new, :create,:destroy]
  
  def new
  end

  def create
    user=User.find_by(username: params[:session][:username].downcase)
    
    respond_to do |format|
      if user && user.authenticate(params[:session][:password])
        if user.email_authen==true
          user_log_in(user)
          params[:session][:remember]=='1' ? user_remember(user) : user_forget(user)
       #   format.html{ redirect_to "http://www.google.com"}
          format.html { friendly_redirect user}
        else
          #  resend email confirmation with a new token if user try to sign in without first authenticating email during sign up
          user.send_email_confirmation
          format.html { redirect_to confirmation_url(user_id:user.id)}
        end
      else
        flash.now[:danger]="Invalid user/password combination"
        format.html {  render 'new'}
      end
    end
  end

  def destroy
    user_log_out if user_logged_in?
    redirect_to user_login_url, notice: "Logged Out"
  end


end
