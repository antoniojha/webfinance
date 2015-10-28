require 'rails_helper'

describe FinancialProduct do
  describe "create financial product" do
    let(:broker) {FactoryGirl.create(:complete_broker)}
    let(:product) {FactoryGirl.create(:product)}  
    let(:company) {FactoryGirl.create(:company)}  
    before do
      @fin_product=FinancialProduct.new(product_id:product.id, broker_id:broker.id,company_id:company.id,name:"test name", description:"test description")
    end   
    subject{@fin_product}
    it {should respond_to(:product_id)}
    it {should respond_to(:broker_id)}
    it {should respond_to(:company_id)}
    it {should respond_to(:name)}
    it {should respond_to(:description)}
    it {should be_valid} 
    describe "when broker_id is not present" do
      before {@fin_product.broker_id=nil}
      it {should_not be_valid}
    end
    describe "when product_id is not present" do
      before {@fin_product.product_id=nil}
      it {should_not be_valid}
    end    
    describe "when company_id is not present" do
      before {@fin_product.company_id=nil}
      it {should_not be_valid}      
    end
    describe "when name is not present" do
      before {@fin_product.name=nil}
      it {should_not be_valid}      
    end 
  end
end
