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
      attach_file "broker_identification", Rails.root+"spec/fixtures/pdfs/example_license.pdf"
      fill_in "Username", with:"antoniojha"
      fill_in "Email", with: "antoniojha@gmail.com"
      fill_in "Password", with:"SecretPassword1?"
      fill_in "Password Confirmation", with: "SecretPassword1?"
      check "broker_license_type_1"
      check "broker_license_type_3"
    end
    it "should create a broker record" do
      expect{click_button "Next"}.to change(Broker,:count).by(1) 
    end
    describe "Page 2 to enter license information" do
      before do
        click_button "Next"
        fill_in "broker_licenses_attributes_0_license_number", with:"license number example1"
        attach_file "broker_licenses_attributes_0_picture", Rails.root+"spec/fixtures/pdfs/example_license.pdf"
        fill_in "broker_licenses_attributes_1_license_number", with:"license number example1"
        attach_file "broker_licenses_attributes_1_picture", Rails.root+"spec/fixtures/pdfs/example_license.pdf"
      end
      it "should create two licenses when submitted" do
        expect{click_button "Next"}.to change(License, :count).by(2)
      end
      it "should direct to summary page when submitted successfully" do
        click_button "Next"
        expect(page).to have_title("WebFinance App|Register Page 3")
      end
      it "should display error if there is a validation error" do
        attach_file "broker_licenses_attributes_0_picture", Rails.root+"spec/fixtures/pdfs/test.docx"
        click_button "Next"
        expect(page).to have_selector(:css,'div.alert.alert-danger', :text=>'The form contains')
      end
      it "should have button to go to previous page" do
        click_button "Prev"
        expect(page).to have_title("WebFinance App|Register Page 1")
      end
      describe "Page 3 to enter license information" do
        before do
          click_button "Next"  
          
        end
        it "should have button to go to previous page" do
          click_button "Prev"
          expect(page).to have_title("WebFinance App|Register Page 2")
        end
        it "should have finish button to go to next page" do
          click_button "Finish"
          expect(page.title).to eq("WebFinance App|Register Page 4-Summary")
        end
        describe "Page 4 to view summary and submit form" do
          before do
            click_button "Finish"
            
          end
          it "should be on page 4" do
            expect(page.title).to eq("WebFinance App|Register Page 4-Summary")
          end
          it "should have button to go to previous page" do
            click_button "Prev"
            expect(page).to have_title("WebFinance App|Register Page 3")
          end
          it "should redirect to broker status sign in page if broker tries to access application without signin in" do
              # test authorize_status_login
              click_button "Save and Close"
              visit edit_broker_path(Broker.last)
              expect(page).to have_title("WebFinance App|Broker Status Login")
              expect(page).to have_content("Please login")
            end
          describe "Final page to view confirmation number" do
            before do
              click_button "Submit"
            end

            it "should direct to the finish page" do
              expect(page.title).to eq("WebFinance App|Broker Initial Confirmation")
            end
            it "should redirect to broker status page once page is submitted and logged in" do
              # test prevent_resubmit method
              visit edit_broker_path(Broker.last)
              expect(page).to have_title("WebFinance App|Broker Application Status")
              expect(page).to have_content("Form already submitted")
            end
            it "should log out" do
              click_button "Save and Close"
              expect(page).to have_title("WebFinance App|Broker Status Login")
            end
            it "should log in and redirect to status page" do
              
              click_button "Save and Close"
              fill_in "Email", with: "antoniojha@gmail.com"
              fill_in "Password", with:"SecretPassword1?"
              click_button "Check Status"
              expect(page).to have_title("WebFinance App|Broker Application Status")
            end
            
          end
        end
      end
    end
  end
end
