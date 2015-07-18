class FinancialGoalStoryRelsController < ApplicationController
  before_action :set_rel, only: [:destroy,:update]
  respond_to :html, :json, :js
  def create
    @financial_goal_story_rel=FinancialGoalStoryRel.new(goal_story_rel_params)
    @story=@financial_goal_story_rel.financial_story
    if @financial_goal_story_rel.save
      redirect_to @story, notice: "this story has been saved."
    else
      @rel_error=true
      render "financial_stories/show"
    end
  end
  def update
    @financial_goal_story_rel.update_attributes(goal_story_rel_params)
    respond_with @financial_goal_story_rel   
  end
  def destroy
    @user=@financial_goal_story_rel.goal.user
    @financial_goal_story_rel.destroy
    respond_to do |format|
      format.html{redirect_to @user}
      format.js{}
    end
  end
  private
  def set_rel
    @financial_goal_story_rel=FinancialGoalStoryRel.find(params[:id])
  end
  def goal_story_rel_params
    params.require(:financial_goal_story_rel).permit(:goal_id,:financial_story_id,:summary)
  end
end
