class FinancialStoriesController < ApplicationController
  before_action :set_story, only:[:show, :edit,:update,:destroy]
  def create
    @broker=Broker.find(params[:broker_id])
    @story=FinancialStory.new(financial_story_params)
    @story.broker_id=@broker.id
    
    respond_to do |format|
      if @story.save
        format.js{}
        format.html{redirect_to @broker}
      else
        @story_error=true
        format.js{}
        format.html{render "brokers/show"}
      end
    end
  end
  def update
    if params[:user_id]
      @author=User.find(params[:user_id])
    elsif params[:broker_id]
      @author=Broker.find(params[:broker_id])
    end
    if params[:upvote]
      @vote=@author.votes.new(financial_story_id:@story.id,description:"up")
    end 
    if params[:cancel_upvote]
      @vote=@author.votes.where(financial_story_id:@story.id).first
      @vote.destroy
      @story.votes=@story.votes-1
      @story.save
    end
    respond_to do |format|
      #this is to vote up or cancel vote by both user and broker
      if params[:upvote] || params[:cancel_upvote]
        @change_vote=true
        if params[:upvote]
          if @vote.save
            @story.votes=@story.votes+1
            @story.save
            format.html{redirect_to @story}
            format.js{}
          else
            format.html{render "financial_stories/show"}
            format.js{}
          end
        else
          format.html{redirect_to @story}
          format.js{}
        end
      else
        # this is to update financial story by broker
        @broker=@story.broker
        @story_id=@story.id
        if @story.update(financial_story_params)
          format.html{redirect_to @story.broker}
          format.js{}
        else
          @story_error=true
          format.html{render "brokers/show"}
          format.js{}
        end
      end
    end
  end
  def edit
  end
  def show
    @vote=Vote.new
    @financial_goal_story_rel=FinancialGoalStoryRel.new
    @edit=params[:edit]
    @author= current_user || current_broker

  end
  def destroy
    @broker=@story.broker
    @story_id=@story.id
    @story.destroy
    
    respond_to do |format|
      format.js{}
      format.html{redirect_to @broker}
    end
  end
  def index
  end
  private
  def financial_story_params
    params.require(:financial_story).permit(:title,:financial_category,:product_id,:description)
  end
  def set_story
    @story=FinancialStory.find(params[:id])
  end

end
