class User::AuthenticatedController < ApplicationController
  before_action :remember_location_user, except:[:create,:update,:destroy] # this comes before authorize_login to be executed first
  before_action :authorize_user_login
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_user

  def invalid_user
    logger.error "Attempt to access user id#{session[:user_id]} that's not existing"
    redirect_to user_login_url, notice: "Invalid User"
  end
  def create
    session[:broker_id_schedule]=params[:broker_id].to_i
    redirect_to new_schedule_url
  end

end