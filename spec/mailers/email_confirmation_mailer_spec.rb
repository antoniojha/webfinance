require "rails_helper"

RSpec.describe EmailConfirmationMailer, :type => :mailer do
  describe "alert" do
    let(:mail) { EmailConfirmationMailer.alert }

    it "renders the headers" do
      expect(mail.subject).to eq("Alert")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "send_email_confirm" do
    let(:mail) { EmailConfirmationMailer.send_email_confirm }

    it "renders the headers" do
      expect(mail.subject).to eq("Send email confirm")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "send_email_remind" do
    let(:mail) { EmailConfirmationMailer.send_email_remind }

    it "renders the headers" do
      expect(mail.subject).to eq("Send email remind")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
