require "rails_helper"

RSpec.describe EmailConfirmationMailer, :type => :mailer do
  before do 
   @user=FactoryGirl.create(:user)
  end
  describe "send_email_confirm" do
    let(:mail) { EmailConfirmationMailer.send_email_confirm(@user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Welcome to WebFinance")
      expect(mail.to).to eq([@user.email])
      expect(mail.from).to eq(["antoniojha@gmail.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
