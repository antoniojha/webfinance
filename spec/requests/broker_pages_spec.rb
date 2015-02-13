require 'rails_helper'

RSpec.describe "BrokerPages", :type => :request do
  describe "Sign Up as a Broker" do
    before do
      visit new_broker_path
      fill_in "First Name", with: "Antonio"
      fill_in "Last Name", with: "Jha"
      fill_in "Company Name", with:"World Financial Group"
      # fill out work address
      fill_in "Street", with:"39-07 Prince Street"
      fill_in "City", with:"Flushing"
      fill_in "State", with:"NY"
      fill_in "broker_phone_work_1", with:"718"
      fill_in "broker_phone_work_2", with:"886"
      fill_in "broker_phone_work_3", with:"5097"
      fill_in "Username", with:"antoniojha"
      fill_in "Email", with: "antoniojha@gmail.com"
      fill_in "Password", with:"SecretPassword1?"
      fill_in "Password Confirmation", with: "SecretPassword1?"
      check "broker_license_type_1"
      check "broker_license_type_3"
    end
    it "should create a temporary broker record" do
      expect{click_button "Next"}.to change(Broker,:count).by(1) 
    end

    describe "next page to enter license information" do
      before do
        click_button "Next"
        fill_in "broker_licenses_attributes_0_license_number", with:"license number example1"
        attach_file "broker_licenses_attributes_0_picture", Rails.root+"spec/fixtures/pdfs/example_license.pdf"
        fill_in "broker_licenses_attributes_1_license_number", with:"license number example1"
        attach_file "broker_licenses_attributes_1_picture", Rails.root+"spec/fixtures/pdfs/example_license.pdf"
      end
      it "should create two licenses when submitted" do
        expect{click_button "Submit"}.to change(License, :count).by(2)
      end
      it "should direct to finish page when submitted successfully" do
        click_button "Submit"
        expect(page).to have_content("Confirmation")
        expect(page).to have_title("WebFinance App|Broker Initial Confirmation")
      end

      it "should display error if there is a validation error" do
        attach_file "broker_licenses_attributes_0_picture", Rails.root+"spec/fixtures/pdfs/test.docx"
        click_button "Submit"
        expect(page).to have_selector(:css,'div.alert.alert-danger', :text=>'The form contains')
      end
      it "should destroy broker if leave the page" do
        expect{visit home_url}.to change(Broker, :count).by(-1)
      end
    end
  end
end
