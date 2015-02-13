class StatusSessionsController < ApplicationController
  include StatusSessionsHelper
  def create
    broker=Broker.find_by(email: params[:status_session][:email])
    broker=Broker.find_by(confirmation_number: params[:status_session][:confirmation_number])
    respond_to do |format|
      if broker && broker.authenticated?(params[:status_session][:confirmation_number])
        status_log_in(broker)
        format.html{redirect_to status_session_path(broker)}
      else
        flash.now[:danger]="Couldn't find your record, please make sure you have the right confirmation."
        format.html{render "new"}
      end
    end

  end
  def show
    @broker=Broker.find(params[:id])
    
  end
end
