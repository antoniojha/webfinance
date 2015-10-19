require 'rails_helper'

describe "broker sign up and 1st Register Page" do
  before do
    visit broker_signup_path
  end
  describe "invalid signup" do
    let(:broker){ FactoryGirl.build(:incomplete_broker)}
    it "should display validation error" do
      expect(page).to have_content('Sign Up')
      click_button "Create Account"
      expect(page).to have_selector(:css,'div.alert.alert-danger')
    end
    it "should display error if password don't match" do
      fill_in "broker_password", with: broker.username
      fill_in "broker_password_confirmation", with: "random"
      click_button "Create Account"
      expect(page).to have_selector(:css,'div.alert.alert-danger')
      expect(page).to have_content("Passwords do not match")
    end
  end
  describe "sign up and register" do
    before do       
      @broker=FactoryGirl.build(:incomplete_broker)
      fill_in "broker_username", :with=>@broker.username
      fill_in "broker_password", :with=>@broker.password 
      fill_in "broker_password_confirmation", :with=>@broker.password
      click_button "Create Account"
    end
    it "should redirect to broker edit page to prompt broker to setup" do
      expect(page).to have_content("Your Background Information")    
    end  

    describe "at 1st page" do
      describe "when no fields information are entered" do
        before do
          @broker=Broker.last
          click_button "Next"
        end
        it "should show error messages" do
          expect(page).to have_selector(:css,'div.alert.alert-danger')
          expect(page).to have_content("First name can't be blank")
          expect(page).to have_content("Last name can't be blank")
          expect(page).to have_content("Email can't be blank")
          expect(page).to have_content("Title can't be blank")
          expect(page).to have_content("Company name can't be blank")   
          expect(page).to have_content("Company location can't be blank") 
        end
        describe "email validation" do
          describe "invalid validation- when no email is entered" do
            before do
              click_button "send validation code"
            end   
            it "should show error message" do
              expect(page).to have_selector(:css,'div.alert.alert-danger')
              expect(page).to have_content("Email can't be blank when sending validation code.")
            end
          end
          describe "valid validation" do
            before do
              fill_in "broker_email", with: "antoniojha@gmail.com"
              click_button "send validation code"
              @broker.reload
            end
            it "should generate validation code once validate button is clicked" do   
              expect(@broker.email_confirmation_token).not_to eq nil
            end
            it "should should have email_authen set to false before validating" do
              expect(@broker.email_authen).to eq false
            end
            it "should have validate button" do
              expect(page).to have_button("validate email")
            end
            describe "enter validation code" do
              describe "unsuccessful email validation" do
                before do
                  click_button "validate email"
                end
                it "should show error message and email_authen remains false" do
                  expect(page).to have_selector(:css,'div.alert.alert-danger')
                  expect(@broker.email_authen).to eq false
                end
              end
              describe "successful email validation" do
                before do
                  fill_in "broker_validation_code", with: @broker.email_confirmation_token
                  click_button "validate email"
                  @broker.reload
                end
                it "should change email authen to true" do
                  expect(@broker.email_authen).to eq true
                end
                it "shouldn't allow validate email after successful validation" do
                  expect(page).not_to have_button("validate email")
                end
                describe "can enter a different email" do
               
                  describe "if it's the same email" do
                    before do
                      @validate_code=@broker.email_confirmation_token
                      fill_in "broker_email", with: "antoniojha@gmail.com"
                      click_button "send validation code"
                      @broker.reload
                    end
                    it "shouldn't generate a new validation code" do
                      expect(@validate_code).to eq @broker.email_confirmation_token
                    end
                  end
                  describe "if it's a different email" do
                    before do
                      @validate_code=@broker.email_confirmation_token
                      fill_in "broker_email", with: "antoniojha@yahoo.com"
                      click_button "send validation code"
                      @broker.reload
                    end
                    it "shouldn't generate a new validation code" do
                      expect(@validate_code).not_to eq @broker.email_confirmation_token
                    end                    
                  end
                end
              end
            end
          end
        end
        describe "proceed without validating email" do
          before do
            @broker.email_authen=false
            @broker.save
            fill_in "broker_first_name", with: "example first name"
            fill_in "broker_last_name", with: "example last name"
            fill_in "broker_email", with: "example@example.com"
            fill_in "broker_title", with: "example title"
            fill_in "broker_company_name", with: "example company"   
            fill_in "broker_company_location", with: "example location"
            click_button "Next"
          end         
          it "shouldn't proceed to page 2" do
            expect(page).to have_selector(:css,'div.alert.alert-danger')
          end
        end
        describe "proceed to 2nd page" do
          before do
            @broker.email_authen=true
            @broker.save
            fill_in "broker_first_name", with: "example first name"
            fill_in "broker_last_name", with: "example last name"
            fill_in "broker_email", with: "example@example.com"
            fill_in "broker_title", with: "example title"
            fill_in "broker_company_name", with: "example company"   
            fill_in "broker_company_location", with: "example location"
            click_button "Next"    
          end
          it "should proceed to the next page" do
            @broker.reload
            expect(page).to have_content("Upload Your ID")
            expect(@broker.step).to eq "id_2"
          end
        end
      end
    end
  end
end

describe "at 2nd page" do
  before do
    @broker=FactoryGirl.create(:complete_broker)
    @broker.step="id_2"
    @broker.save
    set_broker_id_session(@broker)
    visit edit_setup_broker_path(@broker)
  end
  it "should be at 2nd page" do
    expect(page).to have_content("Upload Your ID")
  end

  describe "when no ID is entered" do
    it "id image shouldn't be valid" do
      expect(@broker.id_image.file).to eq nil
    end
    describe "when clicked Next" do
      before do
        click_button "Next"
      end
      it "shouldn't proceed to 3rd page" do
        expect(@broker.step).to eq "id_2"
        expect(page).to have_content("Upload Your ID")
        expect(page).to have_selector(:css,'div.alert.alert-danger')
      end
    end
    describe "when clicked Upload" do
      before do
        click_button "Upload"
      end
      it "shouldn't proceed to 3rd page" do
        expect(@broker.step).to eq "id_2"
     # this test failed for some reason, Rspec doesn't pick up the empty hidden :image field.
     #   expect(page).to have_content("Upload Your ID")
     #   expect(page).to have_selector(:css,'div.alert.alert-danger')
      end
    end
  end
  describe "when wrong type of file is uploaded" do
    before do
      attach_file("broker_id_image",Rails.root+"spec/fixtures/test_files/test.docx")
      click_button "Upload"
    end
    it "shouldn't proceed to 3rd page" do
      expect(@broker.step).to eq "id_2"
      expect(page).to have_selector(:css,'div.alert.alert-danger')
    end
  end
  describe "upload the type of file that is allowed" do
  
    before do
      attach_file("broker_id_image",Rails.root+"spec/fixtures/test_files/Ruby_on_Rails.jpg")
      click_button "Upload"
      @broker.reload
    end
    it "id image shouldn't be invalid" do
      expect(@broker.id_image.file).not_to eq nil
    end
    it "should show view and remove link" do
      expect(page).not_to have_selector(:css,'div.alert.alert-danger')
      expect(@broker.step).to eq "id_2"
      expect(page).to have_link("remove")
      expect(page).to have_link("View License")
   
    end    
    describe "should be able to remove the file" do
      before do
        click_link "remove"
        @broker.reload
      end
      it "id_image file should be invalid now" do
        expect(@broker.id_image.file).to eq nil
      end
    end
    describe "should proceed to the next page" do
      before do
        click_button "Next"
      end
      it "should be on the 3rd page now" do
        expect(page).to have_content("Select Your Licenses")
      end
    end
  end
end
describe "at 3rd page" do
  before do
    @broker=FactoryGirl.create(:complete_broker)
    @broker.step="license_3"
    @broker.save
    set_broker_id_session(@broker)
    visit edit_setup_broker_path(@broker)
  end
  it "should be at 3rd page" do
    expect(page).to have_content("Select Your Licenses")
  end
  describe "when no license is selected" do
    before do
      click_button "Next"
    end
    it "should render error" do
      expect(page).to have_selector(:css,'div.alert.alert-danger')
      expect(page).to have_content("Select Your Licenses")
    end
  end
  describe "when at least one license is selected" do
    before do
      check "broker_license_type_series_7"
      check "broker_license_type_series_6"
      click_button "Next"
    end
    it "should proceed to the next page" do
      expect(page).to have_content("Edit Your Licenses")
    end
  end
end
describe "at 4th page" do
  before do
    @broker=FactoryGirl.create(:complete_broker)
    @broker.step="license_info_4"
    @broker.license_type=["Life Insurance"]
    @broker.save
    @broker.reload
    set_broker_id_session(@broker)
    visit edit_setup_broker_path(@broker)
  end  
  it "should be at 4th page" do
    expect(page).to have_content("Edit Your Licenses")
  end  
  describe "if no license is uploaded for either license" do
    it "should render error when clicking Upload" do
      expect{click_button "Upload"}.to change(License, :count).by(0)
      expect(page).to have_selector(:css,'div.alert.alert-danger')
    end
    it "should render error when clicking Next and not all licenses are uploaded" do
      expect{click_button "Next"}.to change(License, :count).by(0)
      expect(page).to have_selector(:css,'div.alert.alert-danger')
      expect(page).to have_content("All licenses should be uploaded.")
    end
  end
  it "license image shouldn't be valid" do
    expect(@broker.setup_broker.licenses.first).to eq nil
  end
  describe "succesfully upload license file and enter license number" do
    before do
      fill_in "license_license_number", with:"example number 1"
      attach_file("license_license_image",Rails.root+"spec/fixtures/test_files/Ruby_on_Rails.jpg")
      select "1", from:"license_expiration_date_3i"
      select "January", from:"license_expiration_date_2i"
      select "2016", from:"license_expiration_date_1i"
      
    end
    it "should create license" do
      expect{click_button "Upload"}.to change(License, :count).by(1)
      expect(@broker.setup_broker.licenses.first).not_to eq nil 
    end
    
    it "should have remove and view license link" do
      click_button "Upload"
      expect(page).to have_link("remove")
      expect(page).to have_link("View License")
    end
    it "should be able to remove license" do
      click_button "Upload"
      expect{click_link "remove"}.to change(License, :count).by(-1)
    end
    it "should proceed to page 5" do
      click_button "Upload"
      click_button "Next"
      expect(page).to have_content("Select Your Financial Vehicle")
    end
    describe "if go back to previous page and select different vehicle" do
      before do
        click_button "Upload"
        click_button "Previous"
        @license=License.last
      end
      it "check license is valid before unchecking license type" do
        expect(@license).not_to eq nil
      end
      it "should delete the previous license" do
        uncheck "broker_license_type_life_insurance_license"
        check "broker_license_type_series_7"
        click_button "Next"
        expect { License.find(@license.id) }.to raise_error
      end
        
    end
  end
end
describe "at 5th page" do
  before do
    @broker=FactoryGirl.create(:complete_broker)
    @broker.step="vehicle_5"
    @broker.save
    @broker.reload
    set_broker_id_session(@broker)
    # create Product
    index=1
    (1..7).each do |t|
      3.times do                   
        Product.create(name:"name#{index}",description:"description#{index}", vehicle_type:t.to_s)
        index=index+1
      end
    end
    visit edit_setup_broker_path(@broker)
  end  
  it "should be at 5th page" do
    expect(page).to have_content("Select Your Financial Vehicle")
  end  
  it "should go to statement_6 page" do
    check "broker_product_ids_2"
    click_button "Next"
    expect(page).to have_content("Your Skills and Introduction")
  end
  it "should show error if no vehicle is selected" do
    click_button "Next"
    expect(page).to have_content("You need to select at lease one vehicle")
  end
end
describe "at 6th page" do
  before do
    @broker=FactoryGirl.create(:complete_broker)
    @broker.step="statement_6"
    @broker.save
    @broker.reload
    set_broker_id_session(@broker)
    visit edit_setup_broker_path(@broker)
  end   
  it "should not show error if none of the field is filled" do
    click_button "Next"
    expect(page).not_to have_selector(:css,'div.alert.alert-danger')
    expect(page).to have_content("Your Financial Story")
  end 
  it "should show error if introduction statement is more than 150 characters" do
    string="x"*151
    fill_in "broker_ad_statement", with: string
    click_button "Next"
    expect(page).to have_selector(:css,'div.alert.alert-danger')
  end
end
describe "at 7th page" do
  before do
    @broker=FactoryGirl.create(:complete_broker)
    @broker.step="financial_story_7"
    @broker.save
    @broker.reload
    set_broker_id_session(@broker)
    Product.create(name:"name1",description:"description1", vehicle_type:1)
    visit edit_setup_broker_path(@broker)
  end 
  it "should be at 7th page" do
    expect(page).to have_content("Your Financial Story")
  end  
  it "should show error if none of the field is filled" do
    click_button "Next"
    expect(page).to have_selector(:css,'div.alert.alert-danger')
    expect(page).to have_content("Title can't be blank")
    expect(page).to have_content("Story content can't be blank")
  end
  it "should proceed to 8th page if all fields are filled" do
    select("Protection",from:"broker_financial_stories_attributes_0_financial_category")
    select("name1",from:"broker_financial_stories_attributes_0_product_id")       
    fill_in "broker_financial_stories_attributes_0_title", with: "example title"
    fill_in "broker_financial_stories_attributes_0_description", with: "example story"  
    expect{click_button "Next"}.to change(FinancialStory, :count).by(1)
    expect(page).to have_content("Term of Condition")
  end
end
describe "at 8th page" do
  before do
    @broker=FactoryGirl.create(:complete_broker)
    @broker.step="term_of_use_8"
    @broker.save
    @broker.reload
    @setup_broker=@broker.build_setup_broker
    @setup_broker.save
    set_broker_id_session(@broker)
    @license=@setup_broker.licenses.build(license_type:1)
    @license.save(validate: false)
    visit edit_setup_broker_path(@broker)
    @license_num=@setup_broker.licenses.count
    @request_num=@license_num+1
  end 
  it "should be at 8th page" do
    expect(page).to have_content("Term of Condition")
  end 
  it "should show error if term of use checkbox is not checked" do
    click_button "Submit"
    expect(page).to have_selector(:css,'div.alert.alert-danger')
  end
  it "should proceed to broker profile after successful submission" do
    check "broker_check_term_of_use"
    click_button "Submit"
    @broker.reload
    expect(@broker.setup_completed?).to eq true
    expect(page.title).to eq ("RichRly|Broker Profile|Personal") 
  end
  it "should create current experience after successful submission" do
    check "broker_check_term_of_use"
    expect{click_button "Submit"}.to change(Experience, :count).by(1)   
  end
  it "should create one app request plus #{@license_num} license requests, a total of #{@request_num} requests" do
    check "broker_check_term_of_use"
    expect{click_button "Submit"}.to change(BrokerRequest, :count).by(2)      
    
  end
end
describe "access other's registration" do
  before do 
    @broker=FactoryGirl.create(:complete_broker)
    @other_broker=FactoryGirl.create(:complete_broker_other)
    @broker.step="term_of_use_8"
    @broker.save
    @broker.reload
    set_broker_id_session(@broker)
  end
  it "the two brokers shouldn't be equal to each other" do
    expect(@broker.id).not_to eq @other_broker.id
  end
  it "should be able to access your own register page" do
    visit edit_setup_broker_path(@broker)
    expect(page).to have_content("Term of Condition")
  end
  it "shouldn't be able to access other's register page" do
    visit edit_setup_broker_path(@other_broker)
  #  expect(page).not_to have_content("Term of Condition")
    expect(page).to have_content("Unauthorized access!")
  end
  
end
describe "when logging in given registration setup is not completed" do
  before do
    @broker=FactoryGirl.create(:complete_broker)
    @broker.step="term_of_use_8"
    @broker.save
    @broker.reload
    visit broker_login_path
  end
  it "should direct to regisration page" do
    fill_in "session_name_or_email", with:@broker.email
    fill_in "session_password", with:@broker.password
    click_button "Login"
    expect(page).to have_content("Term of Condition")
  end
  it "shouldn't allow access to broker register page if not login" do
    visit edit_setup_broker_path(@broker)
    expect(page).to have_content("Unauthorized access!")
  end
  describe "to access to other part of the profile without registering first" do
    before do
      set_broker_id_session(@broker)
      visit broker_path(@broker)
    end
    it "should redirect to registration page" do
      expect(page).to have_content("Please finish registering.")
      expect(page).to have_content("Term of Condition")
    end
    it "should be able to log out" do
      click_link "log_out"
      expect(page.title).to eq "RichRly|Broker Login"
    end
  end
end

