require 'rails_helper'

describe "Broker pages" do
  before do
    # create vehicles
    index=1
    3.times do                   
      Product.create(name:"name#{index}",description:"description#{index}", vehicle_type: index)
      Company.create(name:"name#{index}",description:"description#{index}",location:"location#{index}")
      index=index+1
    end
    @broker=FactoryGirl.create(:broker)
    setup_broker_requests(@broker)

   # @broker.experiences.create(company:@broker.company_name, title:@broker.title)
    broker_login(@broker)
  end
  
  describe "at the profile page" do
    before do
      visit broker_path(@broker)
    end
    if false
    it "should be at the profile page" do
      expect(page.title).to eq("RichRly|Broker Profile")
    end   
    
    describe "edit profile info section" do
      before do
        click_link "profile_info_edit"
        fill_in "broker_phone_number_work", with: "testing"
        fill_in "broker_phone_number_cell", with: "testing2"
        fill_in "broker_web", with: "test_url"
        click_button "Edit"
      end
      it "should change phone number" do
        @broker.reload
        expect(@broker.phone_number_work).to eq "testing"
        expect(@broker.phone_number_cell).to eq "testing2"
        expect(@broker.web).to eq "test_url"
      end    
    end
    describe "edit about me section" do
      before do
        click_link "about_edit"
        fill_in "broker_ad_statement", with: "test_ad_statement"
        click_button "Edit"
      end     
      it "should change ad statement" do
        @broker.reload
        expect(@broker.ad_statement).to eq "test_ad_statement"
      end
    end
    describe "edit skills & speciality section" do
      before do
        click_link "skills_edit"
        fill_in "broker_skills", with: "test_skills"
        click_button "Edit"
      end    
      it "should change skills" do
        @broker.reload
        expect(@broker.skills).to eq "test_skills"
      end
    end
    describe "edit licenses" do
      before do
        click_link "licenses_edit"
      end
      it "should go to profile setting/licenses page" do
        expect(page).to have_content("Update License")
      end
    end
    describe "edit vehicles" do
      before do
        click_link "vehicles_edit"
      end
      it "should go to profile setting/products page" do
        expect(page).to have_content("Update Vehicle")
      end
      describe "update vehicles" do
        before do
          check "broker_product_ids_2"
          check "broker_product_ids_3"
          click_button "Update Vehicles"
        end
        it "should update the product_ids in broker" do
          @broker.reload
          expect(@broker.product_ids).to eq [1,2,3]
        end
      end
      end
    end
    describe "add individual financial products of each company" do
      before do
        click_link "financial_product_add_0"
        select("name1", from:"financial_product_company_id")
        fill_in "financial_product_name", with: "test product"
      end
      if false
      it "should create product if it's entered the first time" do
        within ".financial_product_add" do
          expect{click_button "Add"}.to change(FinancialProduct, :count).by(1)
        end
      end
      end
      describe "shouldn't save financial product if it does not pass validation" do
        it "if financial product name is not entered" do
          fill_in "financial_product_name", with: ""
          expect{click_button "Add"}.to change(FinancialProduct, :count).by(0)
          expect(page).to have_content("Name can't be blank")
        end
      end
      if false
      describe "shouldn't create financial product if it has same name, company, and vehicle; otherwise, create" do
        before do
          click_button "Add"
        end
        it "shouldn't create given it has same name, company, and vehicle" do
          click_link "financial_product_add_0"
          select("name1", from:"financial_product_company_id")
          fill_in "financial_product_name", with: "test product"
          expect{click_button "Add"}.to change(FinancialProduct, :count).by(0)
        end
        describe "should create if it has a different name, company, or vehicle" do
          it "different name" do
            click_link "financial_product_add_0"
            select("name1", from:"financial_product_company_id")
            fill_in "financial_product_name", with: "test product2"
            expect{click_button "Add"}.to change(FinancialProduct, :count).by(1)            
          end
          it "different company" do
            click_link "financial_product_add_0"
            select("name2", from:"financial_product_company_id")
            fill_in "financial_product_name", with: "test product2"
            expect{click_button "Add"}.to change(FinancialProduct, :count).by(1)            
          end
          it "different vehicle" do
            click_link "financial_product_add_1"
            select("name1", from:"financial_product_company_id")
            fill_in "financial_product_name", with: "test product"
            expect{click_button "Add"}.to change(FinancialProduct, :count).by(1)               
          end
        end
      end
      it "should create Financial Product Relation (linking broker and financial product)" do
        within ".financial_product_add" do
          expect{click_button "Add"}.to change(FinancialProductRel, :count).by(1)
        end
      end
      it "should be able to remove existing financial product" do
        within ".financial_product_add" do
          click_button "Add"
        end
        product=FinancialProduct.last
        expect{click_link "remove_product_#{product.id}"}.to change(FinancialProductRel, :count).by(-1)
      end
      end
    end
    if false
    describe "educations" do
      before do 
        click_link "Add Education"
        select("2013", from:"education_begin_date_1i")
        select("January", from:"education_begin_date_2i")
        select("2015", from:"education_end_date_1i")
        select("January", from:"education_end_date_2i")
        fill_in "education_school", with: "example school"
        fill_in "education_degree", with: "example degree"
        fill_in "education_honors", with: "example honor"
        fill_in "education_description", with: "example description"
        
      end
      describe "shouldn't save education if it does not pass validation" do
        it "if school name is not entered" do
          fill_in "education_school", with: ""
          expect{click_button "Add"}.to change(Education, :count).by(0)
          expect(page).to have_content("School can't be blank")
        end
        it "if degree is not entered" do
          fill_in "education_degree", with: ""
          expect{click_button "Add"}.to change(Education, :count).by(0)
          expect(page).to have_content("Degree can't be blank")          
        end
        it "if end date or start date is not entered" do
          select("", from:"education_begin_date_1i")
          select("", from:"education_begin_date_2i")
          expect{click_button "Add"}.to change(Education, :count).by(0)
          expect(page).to have_content("Begin date can't be blank")          
        end   
        
        it "if end date is before start date" do
          select("2015", from:"education_begin_date_1i")
          select("January", from:"education_begin_date_2i")
          select("2013", from:"education_end_date_1i")
          select("January", from:"education_end_date_2i")   
          expect{click_button "Add"}.to change(Education, :count).by(0)
          expect(page).to have_content("Begin date can't be after end date")      
        end
      end
      it "should add education" do
        expect{click_button "Add"}.to change(Education,:count).by(1)
      end
      describe "should be able to edit education" do
        before do
          click_button "Add"
          @education=Education.last
        end
        it "should edit education" do
          click_link "education_edit_1"
          fill_in "education_school", with: "example school2"
          click_button "Edit"
          @education.reload
          expect(@education.school).to eq "example school2"
        end
      end
      describe "should be able to delete education" do
        before do
          click_button "Add"
        end
        it "should delete education" do
          expect{click_link "education_remove_1"}.to change(Education,:count).by(-1)
        end        
      end
    end
    end
    if false 
    describe "experiences" do
      before do 
        click_link "Add Experience"
        select("2013", from:"experience_begin_date_1i")
        select("January", from:"experience_begin_date_2i")
        select("2015", from:"experience_end_date_1i")
        select("January", from:"experience_end_date_2i")
        fill_in "experience_company", with: "example company"
        fill_in "experience_title", with: "example title"
        fill_in "experience_location", with: "example location"
        fill_in "experience_description", with: "example description"
        
      end    
      describe "shouldn't save experience if it does not pass validation" do
        it "if company name is not entered" do
          fill_in "experience_company", with: ""
          expect{click_button "Add"}.to change(Experience, :count).by(0)
          expect(page).to have_content("Company can't be blank")
        end
        it "if title is not entered" do
          fill_in "experience_title", with: ""
          expect{click_button "Add"}.to change(Experience, :count).by(0)
          expect(page).to have_content("Title can't be blank")          
        end
        it "if end date or start date is not entered" do
          select("", from:"experience_begin_date_1i")
          select("", from:"experience_begin_date_2i")
          expect{click_button "Add"}.to change(Experience, :count).by(0)
          expect(page).to have_content("Begin date can't be blank")          
        end   
        it "if end date is before start date" do
          select("2015", from:"experience_begin_date_1i")
          select("January", from:"experience_begin_date_2i")
          select("2013", from:"experience_end_date_1i")
          select("January", from:"experience_end_date_2i")   
          expect{click_button "Add"}.to change(Experience, :count).by(0)
          expect(page).to have_content("Begin date can't be after end date")      
        end
      end
      it "should add experience" do
        expect{click_button "Add"}.to change(Experience,:count).by(1)
      end
      describe "should be able to edit experience" do
        before do
          click_button "Add"
          @experience=Experience.last
        end
        it "should be on broker edit" do
          expect(page.title).to eq "RichRly|Broker Profile"
        end
        it "should edit experience" do
          expect(Experience.count).to eq 1
          click_link "experience_edit_#{@experience.id}"
          fill_in "experience_title", with: "example title2"
          click_button "Edit"
          @experience.reload
          expect(@experience.title).to eq "example title2"
        end
      end
      describe "should be able to delete experience" do
        before do
          click_button "Add"
          @experience=Experience.last
        end
        it "should delete experience" do
          expect{click_link "experience_remove_#{@experience.id}"}.to change(Experience,:count).by(-1)
        end        
      end
    end
    end
  end
  if false  
  describe "at the profile setting page" do
    before do
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
      describe "email address" do
        before do
          fill_in "broker_email", with: "other_email@example.com"
          click_button "send validation code"
          @broker.reload
          fill_in "broker_validation_code", with: @broker.email_confirmation_token
          click_button "validate email"         
        end
        it "should validate email" do
          @broker.reload
          expect(@broker.email_authen).to eq true
          expect(page).to have_content("Broker was successfully updated.")
        end
        
      end
      describe "broker password" do
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
    end
  end
  end
  if false
  describe "at the personal profile page" do
    before do
      visit broker_path(@broker)
    
    end
    it "should be at the edit page" do
      expect(page.title).to eq("RichRly|Broker Profile")
    end
  end
  end
end
