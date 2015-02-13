class BrokerNotifier < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.broker_notifier.confirm.subject
  #
  def confirm(broker, confirmation_number)
    @greeting = "Hi "+ broker.first_name.capitalize+","
    @broker=broker
    @confirmation_number=confirmation_number
    mail to: broker.email
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.broker_notifier.accepted.subject
  #
  def accepted(broker)
    @greeting = "Hi"+ broker.first_name

    mail to: broker.email
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.broker_notifier.rejected.subject
  #
  def rejected(broker)
    @greeting = "Hi"+ broker.first_name

    mail to: broker.email
  end
 
end
