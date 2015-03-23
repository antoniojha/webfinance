class ApplicationController < ActionController::Base
  helper_method :current_controller
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include ApplicationHelper
  include SessionsHelper

  def delete_temp_broker
    if cookies[:temp_broker_id]
      broker=Broker.find(cookies[:temp_broker_id])  
      if broker
        broker.delete
      end
      cookies.delete(:temp_broker_id)
    end
  end

  def authorize_user_login
    unless user_logged_in?
      flash[:danger]="Please login"
      redirect_to user_login_url
    end
  end
  def authorize_broker_login
    unless broker_logged_in?
      flash[:danger]="Please Login"
      redirect_to broker_login_url
    end
  end
  def authorize_any_login
    unless (user_logged_in? || broker_logged_in?)
      flash[:danger]="Please Login"
      redirect_to user_login_url
    end
  end
  def remember_location_user
    unless user_logged_in?
      remember_desired_location
    end
  end
  def remember_location_broker
    unless broker_logged_in?
      remember_desired_location
    end
  end
  def current_controller
    params[:controller]
  end

end
