module BrokersHelper
  def forget_temp_broker
    cookies.delete(:temp_broker_id)
  end
  def log_in(broker)
    session[:broker_id]=broker.id
  end
  def status_log_in(confirmation_number)
    session[:confirmation_number]=confirmation_number
  end
  
  def current_broker
    if session[:broker_id]
      if @current_broker.nil?
        @current_broker=Broker.find_by(id:session[:broker_id])
      else
        @current_broker
      end
    end
  end
  def broker_logged_in?
    !(current_broker.nil?)
  end
  
end
