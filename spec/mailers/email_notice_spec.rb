require "rails_helper"

RSpec.describe EmailNotice, :type => :mailer do
  describe "application_approval" do
    let(:mail) { EmailNotice.application_approval }

    it "renders the headers" do
      expect(mail.subject).to eq("Application approval")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "application_rejection" do
    let(:mail) { EmailNotice.application_rejection }

    it "renders the headers" do
      expect(mail.subject).to eq("Application rejection")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
