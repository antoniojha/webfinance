class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  before_action :remember_location, except:[:create,:update,:destroy] # this comes before authorize_login to be executed first
  before_action :authorize_login, except: [:about, :contact, :demo, :home, :blog, :faq]
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_user
  
  def invalid_user
    logger.error "Attempt to access user id#{session[:user_id]} that's not existing"
    redirect_to login_url, notice: "Invalid User"
  end
  def authorize_login
    unless logged_in?
      flash[:danger]="Please login"
      redirect_to login_url
    end
  end
  def remember_location
    unless logged_in?
      remember_desired_location
    end
  end
end
