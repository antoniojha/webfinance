class SessionsController < ApplicationController
  skip_before_action :authorize
  def new
  end

  def create
    user=User.find_by(username: params[:session][:username].downcase)
    
    respond_to do |format|
      if user && user.authenticate(params[:session][:password])
        if user.email_authen==true
          log_in(user)
          params[:session][:remember]=='1' ? remember(user) : forget(user)
          format.html { redirect_to user}
        else
          #  resend email confirmation with a new token if user try to sign in without first authenticating email during sign up
          user.send_email_confirmation
          format.html { redirect_to confirmation_url}
        end
      else
        flash.now[:danger]="Invalid user/password combination"
        format.html {  render 'new'}
      end
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to login_url, notice: "Logged Out"
  end


end
