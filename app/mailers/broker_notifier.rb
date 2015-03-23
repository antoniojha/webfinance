class BrokerNotifier < ActionMailer::Base
  include ApplicationHelper
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.broker_notifier.confirm.subject
  #
  def confirm(broker, confirmation_number)
    @greeting = "Hi "+ broker.first_name.capitalize+","
    @broker=broker
    mail to: broker.email
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.broker_notifier.accepted.subject
  #
  def accepted(broker)
    @greeting = "Hi "+ broker.first_name.capitalize+","

    mail to: broker.email
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.broker_notifier.rejected.subject
  #
  def rejected(broker)
    @greeting = "Hi "+ broker.first_name.capitalize+","

    mail to: broker.email
  end
  def quote_request_notification(broker,user,product_type)
    @greeting= "Hi "+ broker.first_name.capitalize+","
    @name=full_name(user)
    product_type=product_type.to_i
    if product_type==1
      @product="life insurance"
    elsif product_type==2
      @product="health insurance"
    elsif product_type==3
      
    end
     
    mail to: broker.email,subject: "Bullish Planner- You Got a New Quote Request"
  end
end
