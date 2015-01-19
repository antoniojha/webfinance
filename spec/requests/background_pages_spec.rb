require 'rails_helper'

RSpec.describe "BackgroundPages", :type => :request do
 
  describe "Background Pages-the 1st page (Background)" do
    before do
      @user=FactoryGirl.create(:user)
      log_in(@user)
      visit new_background_path
      fill_in "background_dob_string", with:"09/18/1987"
      choose "background_married_false"
      fill_in "background_children", with:"3"
      select "New York", from:"background_state"   
    end
    it "should have only next button" do
      expect(page).to have_button "Next"
      expect(page).not_to have_button "Prev"
      # the below test is to make sure that when the user goes back to the edit form (no longer new form) it will still have the correct display
      expect(page.title).to eq("WebFinance App|financial planning page 1")
      click_button "Next"
      expect(page.title).to eq("WebFinance App|financial planning page 2")
      click_button "Prev"
      expect(page).to have_button "Next"
      expect(page).not_to have_button "Prev"
    end
        it "should not yet have right nav link" do
      expect(page).not_to have_link background_nav_link(1)
    end
    it "should display error if one of the field is missing" do
      fill_in "background_dob_string", with:""
      click_button "Next"
      expect(page).to have_content('error')
      expect(page).to have_selector(:css,'div.alert.alert-danger', :text=>'The form contains')

    end
    it "should submit and proceed to the next page" do
      expect{click_button "Next"}.to change(Background,:count).by(1)
      expect(page).to have_title("WebFinance App|financial planning page 2")
      # select based on field id
    end
    describe "Background Pages- the 2nd page (Income)" do
      before do
        # click the next button on 1st page
        click_button "Next"
        fill_in "background_incomes_attributes_0_description", with: "Income 1"
        fill_in "background_incomes_attributes_0_amount", with: "100"
        select "Pay Check", from: "background_incomes_attributes_0_category"
      end
      it "when go to prev page it should save when all the fields are filled" do
        expect{click_button "Prev"}.to change(Income,:count).by(1)
        click_button "Next"
        expect(page).to have_selector("input[value='Income 1']")
      end
      it "when go to prev page it should not save if it is missing one attribute" do
        fill_in "background_incomes_attributes_0_description", with: ""
        expect{click_button "Prev"}.to change(Income,:count).by(0)
        click_button "Next"
        expect(page).not_to have_selector("input[value='Income 1']")
      end
      it "should have right nav link" do
        expect(page).to have_link background_nav_link(2)
        expect(page).not_to have_link background_nav_link(3)
      end
      it "should have both next and previous button" do
        expect(page).to have_button "Next"
        expect(page).to have_button "Prev"
      end
      it "should display error if one of the field is missing" do
        fill_in "background_incomes_attributes_0_description", with:""
        click_button "Next"
        expect(page).to have_content('error')
        expect(page).to have_selector(:css,'div.alert.alert-danger', :text=>'The form contains')
       
      end
      it "should submit/create object and go to the next page" do
     
        expect{click_button "Next"}.to change(Income,:count).by(1)
        expect(page).to have_title("WebFinance App|financial planning page 3")
      end
      it "should create object go back to the previous page" do
        expect{click_button "Prev"}.to change(Income,:count).by(1)
        expect(page).to have_title("WebFinance App|financial planning page 1")
      end
      describe "Background Pages- the 3rd page (Fixed Expense)" do
        before do
          # click the next button on 2nd page
          click_button "Next"
          fill_in "background_fixed_expenses_attributes_0_description", with: "Fixed Expense 1"
          fill_in "background_fixed_expenses_attributes_0_company", with: "Company 1"
          fill_in "background_fixed_expenses_attributes_0_amount", with: "100"
          fill_in "background_fixed_expenses_attributes_0_transaction_date_string", with: Date.today.strftime("%m/%d/%Y")
          select "Insurance", from: "background_fixed_expenses_attributes_0_category"
        end       
        it "when go to prev page it should save when all the fields are filled" do
          expect{click_button "Prev"}.to change(FixedExpense,:count).by(1)
          click_button "Next"
          expect(page).to have_selector("input[value='Fixed Expense 1']")
        end
        it "when go to prev page it should not save if it is missing one attribute" do
          fill_in "background_fixed_expenses_attributes_0_description", with: ""
          expect{click_button "Prev"}.to change(FixedExpense,:count).by(0)
          click_button "Next"
          expect(page).not_to have_selector("input[value='Fixed Expense 1']")
        end
        it "should have right nav link" do
          expect(page).to have_link background_nav_link(3)
          expect(page).not_to have_link background_nav_link(4)
        end
        it "should have both next and previous button" do
          expect(page).to have_button "Next"
          expect(page).to have_button "Prev"
        end
        it "should display error if one of the field is missing" do
          fill_in "background_fixed_expenses_attributes_0_description", with:""
          click_button "Next"
          expect(page).to have_content('error')
          expect(page).to have_selector(:css,'div.alert.alert-danger', :text=>'The form contains')
        end
        it "should submit/create object and go to the next page" do
          expect{click_button "Next"}.to change(FixedExpense,:count).by(1)
          expect(page.title).to eq("WebFinance App|financial planning page 4")
        end
        it "should create object and go back to the previous page" do
          expect{click_button "Prev"}.to change(FixedExpense,:count).by(1)
          expect(page).to have_title("WebFinance App|financial planning page 2")
        end
        describe "Background Pages- the 4th page (Optional Expense)" do
          before do
            # click the next button on 3rd page
            click_button "Next"
            fill_in "background_optional_expenses_attributes_0_description", with: "Optional Expense 1"
            fill_in "background_optional_expenses_attributes_0_amount", with: "100"
            select "Food Expense", from: "background_optional_expenses_attributes_0_category"
          end
          it "should have both next and previous button" do
            expect(page).to have_button "Next"
            expect(page).to have_button "Prev"
          end
          it "should display error if one of the field is missing" do
            fill_in "background_optional_expenses_attributes_0_description", with:""
            click_button "Next"
            expect(page).to have_content('error')
            expect(page).to have_selector(:css,'div.alert.alert-danger', :text=>'The form contains')
          end
          it "should submit/create object and go to the next page" do
            expect{click_button "Next"}.to change(OptionalExpense,:count).by(1)
            expect(page.title).to eq("WebFinance App|financial planning page 5")
          end
          it "should create object and go back to the previous page" do
            expect{click_button "Prev"}.to change(OptionalExpense,:count).by(1)
            expect(page).to have_title("WebFinance App|financial planning page 3")
          end
          describe "Background Pages- the 5th page (Saving)" do
            before do
            # click the next button on 4th page
              click_button "Next"
              fill_in "background_savings_attributes_0_institution_name", with: "Institution 1"
              fill_in "background_savings_attributes_0_description", with: "Saving 1"
              fill_in "background_savings_attributes_0_amount", with: "100"
              select "Cash and Cash Equivalent", from: "background_savings_attributes_0_category"
            end
            it "should have both next and previous button" do
              expect(page).to have_button "Next"
              expect(page).to have_button "Prev"
            end
            it "should display error if one of the field is missing" do
              fill_in "background_savings_attributes_0_description", with:""
              click_button "Next"
              expect(page).to have_content('error')
              expect(page).to have_selector(:css,'div.alert.alert-danger', :text=>'The form contains')
            end
            it "should submit/create object and go to the next page" do
              expect{click_button "Next"}.to change(Saving,:count).by(1)
              expect(page.title).to eq("WebFinance App|financial planning page 6")
            end
            it "should create object and go back to the previous page" do
              expect{click_button "Prev"}.to change(Saving,:count).by(1)
              expect(page).to have_title("WebFinance App|financial planning page 4")
            end
            describe "Background Pages- the 6th page (Propertee)" do
              before do
              # click the next button on 5th page
                click_button "Next"
                fill_in "background_propertees_attributes_0_description", with: "Property 1"
                fill_in "background_propertees_attributes_0_amount", with: "100"
                select "Real Estate", from: "background_propertees_attributes_0_category"

              end

              it "should have both next and previous button" do
                expect(page).to have_button "Next"
                expect(page).to have_button "Prev"
              end
              it "should display error if one of the field is missing" do
                fill_in "background_propertees_attributes_0_description", with:""
                click_button "Next"
                expect(page).to have_content('error')
                expect(page).to have_selector(:css,'div.alert.alert-danger', :text=>'The form contains')
              end
              it "should submit/create object and go to the next page" do
                expect{click_button "Next"}.to change(Propertee,:count).by(1)
                expect(page.title).to eq("WebFinance App|financial planning page 7")
              end
              it "should delete object" do
                expect{click_button "Next"}.to change(Propertee,:count).by(1)
                click_button("Prev")
                expect(page).to have_link("remove")
                expect(page.title).to eq("WebFinance App|financial planning page 6") 
                find(:xpath, "//input[@id='background_propertees_attributes_0__destroy']").set true
                expect(find("#background_propertees_attributes_0__destroy", :visible => false).value).to eq "true"
                expect{click_button "Next"}.to change(Propertee,:count).by(-1) 
                expect(page.title).to eq("WebFinance App|financial planning page 7")
              end
              describe "Background Pages- the 7th page (Debt)" do
                before do
                  # click the next button on 6th page
                  click_button "Next"
                  fill_in "background_debts_attributes_0_description", with: "Debt 1"
                  fill_in "background_debts_attributes_0_institution_name", with: "Institution Name 1"
                  fill_in "background_debts_attributes_0_amount", with: "100"
                  fill_in "background_debts_attributes_0_interest_rate", with: "10"
                  select "Other", from: "background_debts_attributes_0_category"
                end
                it "should have finish and previous button" do
                  expect(page).to have_button "Finish"
                  expect(page).to have_button "Prev"
                  expect(page).not_to have_button "Next"
                end
                it "should display error if one of the field is missing" do
                  fill_in "background_debts_attributes_0_description", with:""
                  expect{click_button "Finish"}.to change(Debt,:count).by(0)
                  expect(page).to have_content('error')
                  expect(page).to have_selector(:css,'div.alert.alert-danger', :text=>'The form contains')
                end
                it "should submit/create object and go to the next page" do
                  expect{click_button "Finish"}.to change(Debt,:count).by(1)
                  expect(page.title).to eq("WebFinance App|Background summary")
                end
              end
            end
          end
        end
      end
    end
  end
end
