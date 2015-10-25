require 'rails_helper'

describe "at the profile setting page-Update Profile" do
  before do
    create_complete_broker
    broker_login(@broker)
    visit edit_broker_path(@broker)
  end
  it "should be at the edit page" do
    expect(page.title).to eq("RichRly|Edit Broker")
  end    
  describe "should be able to edit broker information" do
    describe "broker first and last name" do
      before do
        @first_name=@broker.first_name
        @last_name=@broker.last_name
        first_name=@first_name+"test"
        last_name=@last_name+"test"
        fill_in "broker_first_name", with: first_name
        fill_in "broker_last_name", with: last_name
        click_button "Update Account"
      end
      it "should change info" do
        first_name=@first_name+"test"
        last_name=@last_name+"test"        
        @broker.reload
        expect(@broker.first_name).to eq first_name
        expect(@broker.last_name).to eq last_name
      end
    end
    describe "email validation" do
      describe "invalid validation- when no email is entered" do
        before do
          fill_in "broker_email", with:""
          click_button "send validation code"
        end   
        it "should show error message" do
          expect(page).to have_selector(:css,'div.alert.alert-danger')
          expect(page).to have_content("Email can't be blank when sending validation code.")
        end
      end

      it "broker email_confirmation_token should be blank" do
        expect(@broker.email_confirmation_token).to eq nil
      end
      describe "valid validation" do
        before do
          fill_in "broker_email", with: "other@gmail.com"
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
        describe "when the same email is entered" do
          before do
            @prev_code=@broker.email_confirmation_token
            fill_in "broker_email", with:@broker.email
            click_button "send validation code"
            @broker.reload
            @current_code=@broker.email_confirmation_token
          end           
          it "should generate a new validation code when email address was not validated" do
            expect(@prev_code).not_to eq @current_code
          end
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
            describe "when the same email is entered" do
              before do
                @prev_code=@broker.email_confirmation_token
                fill_in "broker_email", with:@broker.email
                click_button "send validation code"
                @broker.reload
                @current_code=@broker.email_confirmation_token
              end           
              it "shouldn't generate a new validation code when email address was already validated" do
                expect(@prev_code).to eq @current_code
              end
            end
            describe "can't save when a new email is entered other then the one validated" do
              before do
                fill_in "broker_email", with: "other_email@yahoo.com"
                fill_in "broker_first_name", with: "example first name"
                fill_in "broker_last_name", with: "example last name"
                click_button "Update Account"
              end
              it "should render error" do
                expect(page).to have_selector(:css,'div.alert.alert-danger')
              end
            end
            describe "can then validate a different email" do

              describe "if it's the same email" do
                before do
                  @validate_code=@broker.email_confirmation_token
                  fill_in "broker_email", with: "other@gmail.com"
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
    describe "broker password" do
      describe "valid password" do
        before do
          @password=@broker.password
          @password_digest=@broker.password_digest
          fill_in "broker_password", with: @password+"test"
          fill_in "broker_password_confirmation", with: @password+"test"
          click_button "Update Account"
        end
        it "should change password" do
          @broker.reload
          expect(@broker.password_digest).not_to eq @password_digest
        end
      end
      describe "password mismatch" do
        before do
          @password=@broker.password
          fill_in "broker_password", with: @password+"test"
          fill_in "broker_password_confirmation", with: @password+"tes"
          click_button "Update Account"
        end
        it "should change password" do
          expect(page).to have_selector(:css,'div.alert.alert-danger')
        end        
      end
    end  
  end
end
describe "at the profile setting page-My License" do
  before do
    create_complete_broker
    broker_login(@broker)
    visit edit_broker_path(@broker)
    click_link "My License"
  end
  it "should be at My License page" do
    expect(page).to have_content("Update License")
  end
  describe "create license application" do
    describe "valid license" do
      before do 
        select("Health Insurance License",from:"license_license_type")
        select(Date.today.year,from:"license_expiration_date_1i")
        select(Date.today.strftime("%B"),from:"license_expiration_date_2i")
        select(Date.today.day,from:"license_expiration_date_3i")
        fill_in "license_license_number", with:"test"
        attach_file("license_license_image",Rails.root+"spec/fixtures/test_files/Ruby_on_Rails.jpg")
      end
      it "should create license" do
        expect{click_button "Upload License"}.to change(License,:count).by(1)
      end
      it "should create license" do
        expect{click_button "Upload License"}.to change(BrokerRequest,:count).by(1)
      end  
    end
    describe "invalid license" do
      describe "missing required fields and select same license type to be created again" do
        before do 
          #select the same license type as created before
          select("Life Insurance License",from:"license_license_type")
          click_button "Upload License"     
        end
        it "should display error for missing fields and same license type" do
          expect(page).to have_content("License number can't be blank")
          expect(page).to have_content("You have upload this type of license already")
        end
      end
    end
  end
  describe "remove license" do
    it "should have two licenses created" do
      expect(License.count).to eq 2
      expect(page).to have_selector("div.remove-button", count:2)
    end
    it "should remove license" do
      expect{first(:button, "Remove").click}.to change(License,:count).by(-1)
    end
    it "should remove broker_request" do
      expect{first(:button, "Remove").click}.to change(BrokerRequest,:count).by(-1)
    end    
  end
end
describe "at the profile setting page-My Financial Vehicle" do
  before do
    create_complete_broker
    broker_login(@broker)
    visit edit_broker_path(@broker)
    click_link "My Financial Vehicle"
  end
  it "should be at My Financial Vehicle page" do
    expect(page).to have_content("Update Vehicles")
  end
  it "should have product_ids [1,2,3]" do
    expect(@broker.product_ids).to eq [1,2,3] 
  end
  it "should change product_ids" do
    uncheck "broker_product_ids_1"
    click_button "Update Vehicles"
    @broker.reload
    expect(@broker.product_ids).to eq [2,3] 
  end
end
describe "at the profile setting page-Remove Profile" do
  before do
    create_complete_broker
    broker_login(@broker)
    visit edit_broker_path(@broker)
    click_link "Remove Profile"
  end
  it "should be at Remove Profile page" do
    expect(page).to have_content("Remove Profile")
  end
  it "should remove broker from database" do
    fill_in "broker_password", with:@broker.password
    expect{click_button "Delete Profile"}.to change(Broker,:count).by(-1)
    expect(page.title).to eq ("RichRly|Broker Sign Up")
  end
  it "should render error if password is empty" do
    expect{click_button "Delete Profile"}.to change(Broker,:count).by(0)
    expect(page).to have_content("Password doesn't not match")
  end
  it "should render error if password doesn't match" do
    fill_in "broker_password", with:"random"
    expect{click_button "Delete Profile"}.to change(Broker,:count).by(0)
    expect(page).to have_content("Password doesn't not match")    
  end
end