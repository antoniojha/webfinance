class AuthenticationOutController < ApplicationController
  before_action :set_session
  def linkedin
    redirect_to "/auth/linkedin"
  end
  def googleplus
    redirect_to "/auth/google_oauth2"
  end
  def facebook
    redirect_to "/auth/facebook"
  end
  def twitter
    redirect_to "/auth/twitter"
  end
  private
  def set_session
    if params[:user]
      session[:guest]="user"      
    elsif params[:broker]
      session[:guest]="broker"
    end
  end
end
