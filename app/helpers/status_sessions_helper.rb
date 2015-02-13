module StatusSessionsHelper
  def status_log_in(broker)
    session[:confirmation_number]=broker.confirmation_number
  end
end
