class EmailConfirmationMailer < ActionMailer::Base
  default from: "support@richrly.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.alert_notifier.alert.subject
  #

  def send_email_remind(user)
    @greeting = "Hi"
    @warning= "This is an automatically generated email, please do not reply."
    mail to: user.email, subject: 'Alert'
  end
  def send_email_confirm(user)
    @greeting="Dear Customer,"
    @warning= "This is an automatically generated email, please do not reply."
    @user=user
    mail to: user.email, subject: 'Welcome to Richrly'
  end
  def send_password(user,password)
    @greeting="Dear Customer,"
    @user=user
    @password=password
    @warning= "This is an automatically generated email, please do not reply."
    mail to: user.email, subject: 'Your new temporary password'    
  end
end
