class ReceivedEmail < ActionMailer::Base
  default from: "support@richrly.com"
  def send_contact_message(contact)
    @name=contact.name
    @email=contact.email
    @message=contact.message
    @subject=contact.subject
    mail(to: "support@richrly.com", subject: contact.subject) 
  end
end
