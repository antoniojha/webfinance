require 'rails_helper'

describe "Admin Pages" do
  describe "sign up as user-admin" do
    let(:user){FactoryGirl.create(:user)}
    before do
      user.admin=true
      user.save
      user.reload
      user_login(user)
      visit user_path(user)
    end

    it "should be user profile page" do
      expect(page.title).to eq "RichRly|User Profile"
    end
    it "should show admin home link from drop down" do
      expect(page).to have_content("Admin Home")
    end

    describe "access admin page" do
      before do
        click_link("Admin Home")
      end
 
      it "should show links to index to products" do
        expect(page).to have_link("Vehicles")
      end
      it "should show links to index to companies" do
        expect(page).to have_link("Companies")
      end
      it "should show links to index to broker requests" do
        expect(page).to have_link("Requests")
      end
      describe "Vehicle pages" do
        before do 
          (1..10).each do |n|
            Product.create(name:"name#{n}",description:"description#{n}",vehicle_type:"1")
            product=Product.last
            product.product_fin_category_rels.create(vehicle_type:"2",description:"2nd description")
          end
          click_link "Vehicles"
        end
        it "there should be vehicle links on the index page" do
          (1..10).each do |n|
            expect(page).to have_content("name#{n}")
          end
        end
        describe "access new vehicle page" do
          before do
            click_button "Add Vehicle"
          end
          it "should be at the create page" do
            expect(page).to have_content("Enter Financial Vehicle")
          end
          describe "create a new vehicle" do
            before do
              fill_in "product_name", with: "test_name1"
              fill_in "product_description", with: "test_description1"
              select("Debt Management", from: "product_vehicle_type")
            end
            it "should create and redirect to index page" do
              expect{click_button "Create Product"}.to change(Product, :count).by(1)
              expect(page).to have_content("test_name1")
            end
          end
        end
        describe "access vehicle show page" do
          before do
            
            click_link ("name1")
          end
          it "should have button to edit and delete the vehicle" do
            expect(page).to have_button("Edit")
            expect(page).to have_button("Delete")
          end
          describe "access edit page" do
            before do 
              within ".vehicle" do
                click_button "Edit"
              end
              fill_in "product_name", with: "edit_name1"
              click_button "Update Product"
            end
            it "should update the vehicle and display in the index page" do
              expect(page).to have_content("edit_name1")
            end
          end
          describe "delete product" do
            it "should delete the vehicle" do
              expect{click_button "Delete"}.to change(Product, :count).by(-1)
            end
            it "should delete the 2nd relation associated with it" do
              expect{click_button "Delete"}.to change(ProductFinCategoryRel, :count).by(-1)
            end
          end
          describe "access product relation edit page" do
            before do
              within ".product_relation" do
                click_button "Edit"         
              end
              fill_in "product_fin_category_rel_description", with: "edit_description"
              click_button "Update Relation"              
            end
            it "should update" do
              expect(page).to have_content("edit_description")
            end
          end
          describe "delete product relation" do
            it "should delete" do
              expect{click_button "Delete Relation"}.to change(ProductFinCategoryRel, :count).by(-1)
            end
            it "shouldn't delete product itself" do
              expect{click_button "Delete Relation"}.to change(Product, :count).by(0)
            end
          end
          describe "create secondary relation between product and category" do
            before do
              click_link "Add Secondary Relation"
              fill_in "product_fin_category_rel_description", with: "product relation description example"
              select("Retirement", from: "product_fin_category_rel_vehicle_type")
            end
            it "should create a new product relation" do
              expect{click_button "Create Relation"}.to change(ProductFinCategoryRel, :count).by(1)
            end
          end
        end
        it "should be able to click on each link to access show page" do
          (1..10).each do |n|
            click_link ("name#{n}")
            expect(page).to have_content("name#{n}")
            click_link ("Back to index")
          end
        end
        it "should all be in the protection category" do
          click_link "Protection"
           (1..10).each do |n|
            click_link ("name#{n}")
            expect(page).to have_content("name#{n}")
            click_link ("Back to index")
            click_link "Protection"
          end                   
        end
      end
      describe "Company pages" do
        before do
          (1..10).each do |n|
            Company.create(name:"company#{n}",description:"description#{n}",location:"location#{n}")         
          end
          click_link "Companies"          
        end
        it "there should be company links on the index page" do
          (1..10).each do |n|
            expect(page).to have_content("company#{n}")
          end
        end    
        describe "access new company page" do
          before do
            click_button "Add Company"
          end
          it "should be at the create page" do
            expect(page).to have_content("Add a new company")
          end
          describe "create a new company" do
            before do
              fill_in "company_name", with: "test_company1"
              fill_in "company_description", with: "test_description1"
              fill_in "company_location", with: "test_location1"
            end
            it "should create and redirect to index page" do
              expect{click_button "Create Company"}.to change(Company, :count).by(1)
              expect(page).to have_content("test_company1")
            end
          end

        end
        describe "access company show page" do
          before do
            click_link ("company1")
          end
          it "should have button to edit and delete the vehicle" do
            expect(page).to have_button("Edit")
            expect(page).to have_button("Delete")
          end
          describe "access edit page" do
            before do 
              click_button "Edit"
              fill_in "company_name", with: "edit_name1"
              click_button "Update Company"
            end
            it "should update the company and display in the index page" do
              expect(page).to have_content("edit_name1")
            end
          end
          describe "delete company" do
            it "should delete the company" do
              expect{click_button "Delete"}.to change(Company, :count).by(-1)
            end
          end
        end
      end
      describe "Broker Request pages" do
        before do
          @broker=FactoryGirl.create(:broker)
          setup_broker_requests(@broker)
          visit admin_broker_requests_path
        end
        it "should display right title" do
          expect(page.title).to eq ("RichRly|Broker Request")
        end
        it "should be on the broker request page" do
          expect(page).to have_content("Broker Request Page")
        end

        it "all license and broker application should not be approved" do
          expect(@broker.approved).to eq false
          expect(@license1.approved).to eq false
          expect(@license2.approved).to eq false
        end
        it "should show user application and two license application" do
          expect(page).to have_link("#{full_name(@broker)}")
          expect(page).to have_content(@license1.license_number)
          expect(page).to have_content(@license2.license_number)
  
        end
  describe "test non-complementary license appliction approval, disapproval and validation" do
          before do
            @license3=License.create(license_type:"Health Insurance License", license_number: "test3")
            @license3.picture=(Rails.root+"spec/fixtures/pdfs/example_license.pdf").open
            @license3.save
            @broker.broker_requests.create(request_type:"create license", license_id:@license3.id,complement:false,admin_reply:nil)
            visit admin_broker_requests_path
          end
          describe "test disapprove license application" do
            before do
              @request3=BrokerRequest.find_by(license_id:@license3.id)
              within (".disapprove_license_#{@license3.license_number}") do
                click_button "Disapprove"
              end
            end
            describe "fill out comment then disapprove license" do
              
              before do
                fill_in "broker_request_comment", with: "test"
                click_button "Reject"
              end
              it "should disapprove the license application request" do
                @request3.reload
                expect(@request3.admin_reply).to eq "disapprove"
                expect(page).to have_content("Disapproved")
              end
            end                    
          end
          describe "test approve license application" do
            it "should approve license" do
              @request3=BrokerRequest.find_by(license_id:@license3.id)
              expect(@request3.admin_reply).to eq nil
              within (".approve_license_#{@license3.license_number}") do
                click_button "Approve"
              end
              @license3.reload
              @request3.reload
              expect(@request3.admin_reply).to eq "approve"
              expect(@license3.approved).to eq true
            end         
          end
        end
        describe "testing account appliction approval, disapproval and validation" do
          describe "test disapprove license" do
            before do
              @request1=BrokerRequest.find_by(license_id:@license1.id)
              within (".disapprove_license_#{@license1.license_number}") do
                click_button "Disapprove"
              end
            end
            it "should first go to edit page to fill out comment" do
              expect(page).to have_content("Application Dispproval")
            end
            describe "fill out comment then disapprove license" do
              
              before do
                fill_in "broker_request_comment", with: "test"
                click_button "Reject"
              end
              it "should disapprove the license application request" do
                @request1.reload
                expect(@request1.admin_reply).to eq "disapprove"
                expect(page).to have_content("Disapproved")
              end

            end
          end
          describe "test approve license" do
            it "should approve license" do
              @request1=BrokerRequest.find_by(license_id:@license1.id)
              expect(@request1.admin_reply).to eq nil
              within (".approve_license_#{@license1.license_number}") do
                click_button "Approve"
              end
              @license1.reload
              @request1.reload
              expect(@request1.admin_reply).to eq "approve"
              expect(@license1.approved).to eq true
            end
            it "should not allow user account to be accepted without first approving licenses" do
              within ".approve_account" do
                click_button "Approve"
              end
              expect(page).to have_content("Account for #{full_name(@broker)} can't be approved since license(s) number #{@license1.license_number} has not been approved.")
              expect(page).to have_content("Account for #{full_name(@broker)} can't be approved since license(s) number #{@license2.license_number} has not been approved.")
            end
            describe "when one license is rejected, the broker application can't be approved" do
              before do
                @request1=BrokerRequest.find_by(license_id:@license1.id)
                @request1.admin_reply="disapprove"
                @request1.save
              end
              it "should not allow user account to be approved" do
                  within ".approve_account" do
                    click_button "Approve"
                  end
                  expect(page).to have_content("Account for #{full_name(@broker)} can't be approved since license(s) number #{@license1.license_number} was disapproved.")
                  expect(page).to have_content("Account for #{full_name(@broker)} can't be approved since license(s) number #{@license2.license_number} has not been approved.")
              end
            end
            describe "even when one license is accepted, the broker application is still rejected if not all licenses are approved" do
              before do
                within (".approve_license_#{@license1.license_number}") do
                  click_button "Approve"
                end  
                within ".approve_account" do
                  click_button "Approve"
                end
              end
              it "should reject broker application" do
                expect(page).to have_content("Account for #{full_name(@broker)} can't be approved since license(s) number #{@license2.license_number} has not been approved.")
              end
            end
            describe "admin approve all licenses then approves the application" do
              before do
                within (".approve_license_#{@license1.license_number}") do
                  click_button "Approve"
                end
                within (".approve_license_#{@license2.license_number}") do
                  click_button "Approve"
                end
                within ".approve_account" do
                  click_button "Approve"
                end
             #   expect(page).not_to have_content("error")
                @broker.reload
              end
              it "should approve broker" do
                expect(@broker.approved).to eq true
              end
              it "should send out approval email" do
                expect(last_email.to).to include (@broker.email)
              end
            end
            describe "test disapprove broker account application" do
              before do
                within (".disapprove_account") do
                  click_button "Disapprove"
                end
              end
              it "should first go to edit page to fill out comment" do
                expect(page).to have_content("Application Dispproval")
              end
              describe "fill out comment then disapprove license" do

                before do
                  @request=BrokerRequest.find_by(request_type:"create account")
                  fill_in "broker_request_comment", with: "test"
                  click_button "Reject"
                end
                it "should disapprove the license application request" do
                  @request.reload
                  expect(@request.admin_reply).to eq "disapprove"
                  expect(page).to have_content("Disapproved")
                end
                it "should send out disapproval email" do
                  @broker=Broker.find(@request.broker_id)
                  expect(last_email.to).to include (@broker.email)
                end
              end
            end
          end
        end
      end
    end
  end
end
