class Broker::SessionsController < Broker::AuthenticatedController
  skip_before_action :authorize_broker_login, only: [:new, :create,:destroy]
  skip_before_action :redirect_to_complete_broker_profile
  skip_before_action :remember_location_broker, only:[:new]
  def new
    # serves as blank broker object for @broker.error.
    @broker=Broker.new
  end
  def create

      name_or_email=params[:session][:name_or_email].downcase
      broker=Broker.find_by(username: name_or_email) || Broker.find_by(email: name_or_email)
      respond_to do |format|
        if broker && broker.has_password?(params[:session][:password])
          broker_log_in(broker)
          format.html{ friendly_redirect broker}
        else
          @broker=Broker.new
          flash.now[:danger]="Invalid username or email/password combination"
          format.html {  render 'new'}
        end
      end
  end
  def destroy
    broker_log_out if broker_logged_in?
    redirect_to broker_login_url, notice: "Logged Out"
  end
end