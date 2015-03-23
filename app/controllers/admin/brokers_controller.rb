class Admin::BrokersController < ApplicationController
 
  skip_before_action :authorize_login
  before_action :set_broker, only:[:show]
  def index
    @brokers_p=Broker.where(status:"pending")
    @brokers_a=Broker.where(status:"accepted")
    @brokers_r=Broker.where(status:"rejected")
  end
  def show
    @comment=ApplicationComment.new
  end
  private
  def set_broker
    @broker=Broker.find(params[:id])
  end
end