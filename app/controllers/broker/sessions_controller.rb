class Broker::SessionsController < Broker::AuthenticatedController
  skip_before_action :authorize_broker_login, only: [:new, :create,:destroy]
  skip_before_action :remember_location_broker, only:[:new]
  def new
    
  end
  def create
    broker=Broker.find_by(username: params[:session][:username].downcase)
    respond_to do |format|
      if broker && broker.authenticate(params[:session][:password])
        broker_log_in(broker)
        format.html{ friendly_redirect broker}
      else
        flash.now[:danger]="Invalid broker/password combination"
        format.html {  render 'new'}
      end
    end
  end
  def destroy
    broker_log_out if broker_logged_in?
    redirect_to broker_login_url, notice: "Logged Out"
  end
end