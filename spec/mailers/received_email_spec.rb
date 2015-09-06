require "rails_helper"

RSpec.describe ReceivedEmail, :type => :mailer do
  describe "send_contact_message" do
    let(:mail) { ReceivedEmail.send_contact_message }

    it "renders the headers" do
      expect(mail.subject).to eq("Send contact message")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
