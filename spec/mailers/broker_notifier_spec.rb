require "rails_helper"

RSpec.describe BrokerNotifier, :type => :mailer do
  describe "confirm" do
    let(:mail) { BrokerNotifier.confirm }

    it "renders the headers" do
      expect(mail.subject).to eq("Confirm")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "accepted" do
    let(:mail) { BrokerNotifier.accepted }

    it "renders the headers" do
      expect(mail.subject).to eq("Accepted")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "rejected" do
    let(:mail) { BrokerNotifier.rejected }

    it "renders the headers" do
      expect(mail.subject).to eq("Rejected")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
