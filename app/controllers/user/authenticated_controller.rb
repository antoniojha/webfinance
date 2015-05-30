class User::AuthenticatedController < ApplicationController
  before_action :remember_location_user, except:[:create,:update,:destroy] # this comes before authorize_login to be executed first
  before_action :authorize_user_login
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_user
  before_action :redirect_to_user_setup
  before_action :redirect_to_complete_user_profile
  def invalid_user
    logger.error "Attempt to access user id#{session[:user_id]} that's not existing"
    redirect_to user_login_url, notice: "Invalid User"
  end
  def create
    remember_broker(params[:broker_id])
    
    redirect_to new_schedule_url
  end

end