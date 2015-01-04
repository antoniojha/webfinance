require 'rails_helper'

describe Background do
  describe "Create Background" do
    before do
      @background=FactoryGirl.build(:background)
    end
    subject{@background}
    it{should respond_to(:dob)}
    it{should respond_to(:married)}
    it{should respond_to(:children)}
    it{should respond_to(:state)}
    describe "shouldn't save when dob is not entered" do
      before{@background.dob_string=""}
      it{should_not be_valid}
    end
    describe "shouldn't save when dob is in the future" do
      before{@background.dob_string=Time.zone.tomorrow.strftime('%m/%d/%Y')}
      it{should_not be_valid}
    end
    describe "shouldn't save when relationship status is not entered" do
      before{@background.married=""}
      it{should_not be_valid}
    end
    describe "shouldn't save when children(how many dependent) is not entered" do
      before{@background.children=""}
      it{should_not be_valid}
    end
    describe "shouldn't save when state is not entered" do
      before{@background.state=""}
      it{should_not be_valid}
    end

    describe "Savings" do
      before do
        @saving=FactoryGirl.build :saving, background:@background
        @valid_params={institution_name:"valid",description:"valid",amount:"100",category:"1"}
        @valid_params2={institution_name:"",description:"",amount:"",category:""}
        @invalid_params={institution_name:"",description:"valid",amount:"100",category:"1"}
      end
      subject{@saving}
      it {should respond_to(:institution_name)}
      it {should respond_to(:description)}
      it {should respond_to(:amount)}
      it {should respond_to(:category)}
      describe "should't save if amount is less than 0" do
        before{@saving.amount="-100"}
        it{should_not be_valid}
      end
      describe "when one of the attribute is missing" do
        it "shouldn't be valid" do
          @background.savings.build(@invalid_params)
          expect(@background.save).to eq false
        end
      end
      describe "when all the attributes are missing" do
        it "should be valid" do         
          @background.savings.build(@valid_params)
          expect(@background.save).to eq true
          @background.savings.build(@valid_params2)
          expect(@background.save).to eq true
        end
      end
    end
    describe "Debt" do
      before do
        @debt=FactoryGirl.build :debt, background:@background
        @valid_params={institution_name:"valid",description:"valid",amount:"100", interest_rate:"10"}
        @valid_params2={institution_name:"",description:"",amount:"",interest_rate:""}
        @invalid_params={institution_name:"",description:"valid",amount:"100",interest_rate:"10"}
      end
      subject{@debt}
      it {should respond_to(:institution_name)}
      it {should respond_to(:description)}
      it {should respond_to(:amount)}
      it {should respond_to(:interest_rate)}
      describe "should't save if amount is less than 0" do
        before{@debt.amount="-100"}
        it{should_not be_valid}
      end
      describe "shouldn't save if amount is equal 0" do
        before{@debt.amount="0"}
        it{should_not be_valid}
      end
      describe "should't save if interest is less than 0" do
        before{@debt.interest_rate="-1"}
        it{should_not be_valid}
      end
      describe "should save if interest is equal 0" do
        before{@debt.interest_rate="0"}
        it{should be_valid}
      end
      describe "when one of the attribute is missing" do
        it "shouldn't be valid" do
          @background.debts.build(@invalid_params)
          expect(@background.save).to eq false
        end
      end
      describe "when all the attributes are correct" do
        it "should be valid" do
          @background.debts.build(@valid_params)
          expect(@background.save).to eq true
        end
      end   
      describe "when all the attributes are missing" do
        it "should be valid" do         
          @background.debts.build(@valid_params2)
          expect(@background.save).to eq true
        end
      end     
    end
    describe "Income" do
      before do
        @income=FactoryGirl.build :income, background:@background
        @valid_params={description:"valid",amount:"100", category:"1"}
        @valid_params2={description:"",amount:"",category:""}
        @invalid_params={description:"",amount:"100",category:"1"}
      end
      subject{@income}
      it {should respond_to(:description)}
      it {should respond_to(:amount)}
      it {should respond_to(:category)}
      describe "should't save if amount is less than 0" do
        before{@income.amount="-100"}
        it{should_not be_valid}
      end
      describe "when one of the attribute is missing" do
        it "shouldn't be valid" do
          @background.incomes.build(@invalid_params)
          expect(@background.save).to eq false
        end
      end
      describe "when all the attributes are correct" do
        it "should be valid" do
          @background.incomes.build(@valid_params)
          expect(@background.save).to eq true
        end
      end   
      describe "when all the attributes are missing" do
        it "should be valid" do         
          @background.incomes.build(@valid_params2)
          expect(@background.save).to eq true
        end
      end  
    end
    describe "Fixed Expense" do
      before do
        @f_expense=FactoryGirl.build :fixed_expense, background:@background
        @valid_params={description:"valid",amount:"100",company:"valid",transaction_date_string:"01/02/2015", category:"1"}
        @valid_params2={description:"",amount:"",company:"",transaction_date:"",category:""}
        @invalid_params={description:"",amount:"100",company:"valid",transaction_date:"01/02/2015",category:"1"}
      end
      subject{@f_expense}
      it {should respond_to(:description)}
      it {should respond_to(:amount)}
      it {should respond_to(:company)}
      it {should respond_to(:transaction_date)}
      it {should respond_to(:category)}
      describe "shouldn't save if amount is less than 0" do
        before{@f_expense.amount="-100"}
        it{should_not be_valid}
      end
      describe "shouldn't save if transaction date is in the future" do
        before{@f_expense.transaction_date=Time.zone.tomorrow}
        it{should_not be_valid}
      end
      describe "shouldn't save when transaction date is in the future" do
        before{@f_expense.transaction_date_string=Time.zone.tomorrow.strftime('%m/%d/%Y')}
        it{should_not be_valid}
      end
      describe "should't save if amount is less than 0" do
        before{@f_expense.amount="-100"}
        it{should_not be_valid}
      end
      describe "when one of the attribute is missing" do
        it "shouldn't be valid" do
          @background.fixed_expenses.build(@invalid_params)
          expect(@background.save).to eq false
        end
      end
      describe "when all the attributes are correct" do
        it "should be valid" do
          @background.fixed_expenses.build(@valid_params)
          expect(@background.save).to eq true     
        end
      end   
      describe "when all the attributes are missing" do
        it "should be valid" do         
          @background.fixed_expenses.build(@valid_params2)
          expect(@background.save).to eq true
        end
      end  
    end
    describe "Fixed Expense" do
      before do
        @o_expense=FactoryGirl.build :optional_expense, background:@background
        @valid_params={description:"valid",amount:"100",category:"1"}
        @valid_params2={description:"",amount:"",category:""}
        @invalid_params={description:"",amount:"100",category:"1"}
      end
      subject{@o_expense}
      it {should respond_to(:description)}
      it {should respond_to(:amount)}
      it {should respond_to(:category)}
      describe "shouldn't save if amount is less than 0" do
        before{@o_expense.amount="-100"}
        it{should_not be_valid}
      end
      describe "when one of the attribute is missing" do
        it "shouldn't be valid" do
          @background.optional_expenses.build(@invalid_params)
          expect(@background.save).to eq false
        end
      end
      describe "when all the attributes are correct" do
        it "should be valid" do
          @background.optional_expenses.build(@valid_params)
          expect(@background.save).to eq true     
        end
      end   
      describe "when all the attributes are missing" do
        it "should be valid" do         
          @background.optional_expenses.build(@valid_params2)
          expect(@background.save).to eq true
        end
      end  
    end
  end
end

