
require 'rails_helper'

describe "broker sign in" do
  before do
    visit broker_login_path
  end
  describe "sign in when broker's has not confirmed email yet" do
    before do       
      @broker=FactoryGirl.create(:incomplete_broker)
      fill_in "session_name_or_email", :with=>@broker.username
      fill_in "session_password", :with=>@broker.password 
      click_button "Login"
      #create vehicles which will later be selected
      index=1
      (1..7).each do |t|
         3.times do                   
           Product.create(name:"name#{index}",description:"description#{index}", vehicle_type:t)
           index=index+1
         end
       end
    end
    it "should redirect to broker edit page to prompt broker to setup" do
      expect(page).to have_content("Enter Your Background Information")    
    end   
    describe "at 1st page" do
      describe "when no fields information are entered" do
        before do
          click_button "Next"
        end
        it "show error messages" do
          expect(page).to have_content("error")
          expect(page).to have_content("First name can't be blank")
          expect(page).to have_content("Last name can't be blank")
          expect(page).to have_content("Email can't be blank")
          expect(page).to have_content("Title can't be blank")
          expect(page).to have_content("Company name can't be blank")   
          expect(page).to have_content("Company location can't be blank") 
        end
      end
      if false
      describe "at 2nd page" do
        before do
          fill_in "broker_first_name", with: "example first name"
          fill_in "broker_last_name", with: "example last name"
          fill_in "broker_email", with: "example@example.com"
          fill_in "broker_title", with: "example title"
          fill_in "broker_company_name", with: "example company"   
          fill_in "broker_company_location", with: "example location"

          click_button "Next"
        end
        it "should go to the second page license" do
          expect(page).to have_content("Select Your Licenses")
        end
        it "should show error messages when no license is selected" do
          click_button "Next"
          expect(page).to have_content("error")
          expect(page).to have_content("Need to select a license")       
        end
        describe "at 3rd page" do
          before do
            check "broker_license_type_series_7"
            check "broker_license_type_series_6"
            click_button "Next"
          end
          it "should go to the 3rd page" do
            expect(page).to have_content("Upload Your Licenses")
          end
          it "should show error messages when no licenses are uploaded" do
            click_button "Next"
            expect(page).to have_content("error")
            expect(page).to have_content("Attachment(s) can't be blank")
            expect(page).to have_content("License number(s) can't be blank")
          end
          describe "successful creating, edit and removing licenses" do
            before do
              fill_in "setup_broker_licenses_attributes_0_license_number", with:"example number 1"
              fill_in "setup_broker_licenses_attributes_1_license_number", with: "example number 2"
              attach_file("setup_broker_licenses_attributes_0_picture",Rails.root+"spec/fixtures/images/Ruby_on_Rails.jpg")
              attach_file("setup_broker_licenses_attributes_1_picture",Rails.root+"spec/fixtures/images/Ruby_on_Rails.jpg")
              
            end
            it "should create two new records" do
              expect{click_button "Next"}.to change(License, :count).by(2)  
            end
            describe "uploaded licenses and going back to the previous page" do
              before do
                click_button "Next"
                click_button "Previous"
              end
              describe "goes back to page 3" do
  
                it "should successfully update" do
                  fill_in "setup_broker_licenses_attributes_0_license_number", with:"example number 1 update"
                  click_button "Next"
                  expect(page).to have_content("Select Your Financial Vehicle")
                end
                it "should give error if update fails validation such as missing license number" do
                  fill_in "setup_broker_licenses_attributes_0_license_number", with:""
                  click_button "Next"
                  expect(page).to have_content("error")
                end
              end
              describe "goes back to page 2" do
                before{ click_button "Previous"}
                it "should be back in page 2" do
                  expect(page).to have_content("Select Your Licenses")
                end
                it "should delete series 7 license when uncheck the previous selection" do
                  uncheck "broker_license_type_series_7"
                  expect{click_button "Next"}.to change(License, :count).by(-1) 
                end
                it "should build an instance of series 3 license when check an additional license" do
                  check "broker_license_type_series_3"
                  click_button "Next"
                  expect(page).to have_content("Series 3")
                end
              end
            end
            describe "at vehicle_4 page" do
              before do

                click_button "Next"
              end
              it "should go to vehicle_4 page" do 
                expect(page).to have_content("Select Your Financial Vehicle")
              end
              it "should show error message if no vehicle is selected" do
                click_button "Next"
                expect(page).to have_content("error")
                expect(page).to have_content("Need to select a Vehicle")
              end
              describe "at product_info_5 page" do
                before do
                  check "broker_product_names_name1"
                  click_button "Next"
                end
                it "should go to product_info_5 page" do
                  expect(page).to have_content("Your Skills and Statement")
                end
                it "should show no error if no skills or statements are entered" do
                  click_button "Next"
                  expect(page).not_to have_content("error")
                end
                describe "at register_approve_info_6 page" do
                  before do
                    fill_in "broker_skills", with: "example skills"
                    fill_in "broker_ad_statement", with: "example statement"
                    click_button "Next"
                  end
                  it "should go to the page 6" do
                    expect(page).to have_content("Your Story")
                  end
                  it "should display error if no story is entered" do
                    click_button "Next"
                    expect(page).to have_content("error")
                    expect(page).to have_content("Vehicle can't be blank")
                    expect(page).to have_content("Financial category can't be blank")
                    expect(page).to have_content("Story can't be blank")
                  end
                  describe "fillin out page 6" do
                    before do
                      select("Protection",from:"broker_financial_category")
                      select("name1",from:"broker_product_id")                     
                      fill_in "broker_story", with: "example story"                  
                    end
                    it "should go to page 7" do
                      click_button "Next"
                      expect(page).to have_content("Term of Use")
                    end
                    it "should create one Financial Story object" do
                      expect{click_button "Next"}.to change(FinancialStory, :count).by(1) 
                    end
                    describe "at page 7 term_of_use_7" do
                      before do
                        click_button "Next"
                      end
                      it "should go to page 7" do
                        expect(page).to have_content("Term of Use")
                      end
                      it "should display error if agreement checkbox not checked" do
                        click_button "Submit"
                        expect(page).to have_content("error")
                        expect(page).to have_content("You have to agree to term of use condition to be registered on Richrly")
                      end
                      describe "successfully submitting the application" do
                        before do
                          check "broker_check_term_of_use"
                          click_button "Submit"
                        end
                        it "should directs to user edit page" do
                          expect(page).to have_title("RichRly|Edit Broker")
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    end
  end
end
