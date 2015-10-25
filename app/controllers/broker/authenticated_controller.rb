class Broker::AuthenticatedController < ApplicationController
  before_action :remember_location_broker, only:[:edit,:home] # this comes before authorize_login to be executed first. Primarily used for Broker action:edit
  before_action :authorize_broker_login
  before_action :redirect_to_broker_setup
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_broker
  

#  before_action :set_cache_buster
  def invalid_broker
    logger.error "Attempt to access broker id#{session[:broker_id]} that's not existing"
    redirect_to broker_login_url, notice: "Invalid Broker"
  end
end