class EmailConfirmationMailer < ActionMailer::Base
  default from: "Antonio Jha <antoniojha@gmail.com>"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.alert_notifier.alert.subject
  #
  def send_email_remind(user)
    @greeting = "Hi"

    mail to: user.email, subject: 'Alert'
  end
  def send_email_confirm(user)
    @greeting="Dear Customer,"
    @user=user
    mail to: user.email, subject: 'Welcome to WebFinance'
  end

end
