require 'rails_helper'

describe FinancialStory do
  describe "create financial story" do
    let(:broker) {FactoryGirl.create(:complete_broker)}
    let(:product) {FactoryGirl.create(:product)}
    before do
      @fin_story=FinancialStory.new(product_id:product.id, broker_id:broker.id,title:"test title",financial_category:"1", description:"test")
    end
    subject{@fin_story}
    it {should respond_to(:product_id)}
    it {should respond_to(:broker_id)}
    it {should respond_to(:financial_category)}
    it {should respond_to(:description)}
    it {should respond_to(:title)}
    it {should be_valid}
    describe "when broker_id is not present" do
      before {@fin_story.broker_id=nil}
      it {should_not be_valid}
    end
    describe "when product_id is not present" do
      before {@fin_story.product_id=nil}
      it {should_not be_valid}
    end
    describe "when financial category is blank" do
      before {@fin_story.financial_category=nil}
      it {should_not be_valid}
    end
    describe "when title is blank" do
      before {@fin_story.title=nil}
      it {should_not be_valid}      
    end
    describe "when description is blank" do
      before {@fin_story.description=nil}
      it {should_not be_valid}      
    end
  end
  describe "test dependencies" do
    let(:broker) {FactoryGirl.create(:complete_broker)}
    let(:product) {FactoryGirl.create(:product)}
    before do
      @fin_story=FinancialStory.create(product_id:product.id, broker_id:broker.id,title:"test title",financial_category:"1", description:"test")
    end      
    describe "micro_comments" do
      before do
        micro_comment=@fin_story.micro_comments.build
        micro_comment.save(validate:false)
      end
      it "should have one micro_comment" do
        expect(MicroComment.count).to eq 1
      end
      it "should remove micro_comment" do
        @fin_story.destroy
        expect(MicroComment.count).to eq 0   
      end
    end
    describe "financial_goal_story_rels" do
      before do
        financial_goal_story_rel=@fin_story.financial_goal_story_rels.build
        financial_goal_story_rel.save(validate:false)
      end
      it "should have one financial_goal_story_rel" do
        expect(FinancialGoalStoryRel.count).to eq 1
      end
      it "should remove financial_goal_story_rel" do
        @fin_story.destroy
        expect(FinancialGoalStoryRel.count).to eq 0   
      end
    end  
    describe "acitivities" do
      before do
        activity=@fin_story.activities.build
        activity.save(validate:false)
      end
      it "should have one activity" do
        expect(Activity.count).to eq 1
      end
      it "should remove activity" do
        @fin_story.destroy
        expect(Activity.count).to eq 0   
      end
    end      
  end
end
