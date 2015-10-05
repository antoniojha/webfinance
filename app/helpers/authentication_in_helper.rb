module AuthenticationInHelper
  def authenticate_create(guest)
    if guest=="user"
      user_create
    elsif guest=="broker"
      broker_create
    end
  end
  private

  def user_create
#    raise env['omniauth.auth'].to_yaml
   
    if env['omniauth.auth']
    user=User.from_omniauth(env['omniauth.auth'])
      if user.save
        user_log_in(user)
        unless user.setup_completed?
          redirect_to_setup
        else
          friendly_redirect(user,"Signed in.")
        end
      else
        @user=user
        render "user/sessions/new"
      end
    end
  end
  def broker_create
  #  raise env['omniauth.auth'].to_yaml
    if env['omniauth.auth']
      broker=Broker.from_omniauth(env['omniauth.auth'])
      if broker.save
        broker_log_in(broker)
        unless broker.setup_completed?
          redirect_to broker_setup_path(broker)
        else
          friendly_redirect(broker,"Signed in.")
        end
      else
        @broker=broker
        render "broker/sessions/new"
      end
    end
  end
end
