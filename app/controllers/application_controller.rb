class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_user
  
  def invalid_user
    logger.error "Attempt to access user id#{session[:user_id]} that's not existing"
    redirect_to login_url, notice: "Invalid User"
  end
end
