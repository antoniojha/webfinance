class AdvicesController < ApplicationController
 # before_action :authorize_broker_login, only: [:new,:update,:create,:delete]
  
  def new
    @advice=Advice.new
  end
end
