class EmailNotice < ActionMailer::Base
  include ApplicationHelper
  default from: "support@richrly.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.email_notice.application_approval.subject
  #
  def application_approval(broker)
    @greeting = "Dear #{full_name(broker)}"
  
    mail to: broker.email
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.email_notice.application_rejection.subject
  #
  def application_rejection(broker)
    @greeting = "Dear #{full_name(broker)}"

    @complement_requests=BrokerRequest.where(broker_id:broker.id,complement:true)
    mail to: broker.email
  end

end
