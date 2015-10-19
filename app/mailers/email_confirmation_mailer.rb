class EmailConfirmationMailer < ActionMailer::Base
  default from: "support@richrly.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.alert_notifier.alert.subject
  #

  def send_email_remind(member)
    @greeting = "Hi"
    @warning= "This is an automatically generated email, please do not reply."
    mail to: member.email, subject: 'Alert'
  end
  def send_email_confirm(member)
    @greeting="Dear Customer,"
    @warning= "This is an automatically generated email, please do not reply."
    @member=member
    mail to: member.email, subject: 'Welcome to Richrly'
  end
  def send_password_reset(member)
    @greeting="Dear Customer,"
    @member=member
    @warning= "This is an automatically generated email, please do not reply."
    mail to: member.email, subject: 'To reset your password'    
  end
end
