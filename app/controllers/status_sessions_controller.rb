class StatusSessionsController < ApplicationController
  include BrokersHelper
  skip_before_action :authorize_login
  def create
    broker=Broker.find_by(email: params[:status_session][:email].downcase)
    respond_to do |format|
      if broker && broker.authenticate(params[:status_session][:password])
        broker_log_in(broker)
        if broker.status
          format.html{redirect_to register_broker_status_url(id:broker)}
        else
          format.html{redirect_to edit_register_broker_url(id:broker)}
        end
      else
        flash.now[:danger]="Couldn't find your record, please make sure you have the right information."
        format.html{render "new"}
      end
    end

  end
  def show
    @broker=Broker.find(params[:id])
    
  end
end
