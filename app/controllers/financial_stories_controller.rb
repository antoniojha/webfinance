class FinancialStoriesController < ApplicationController
  before_action :set_story, only:[:show, :edit,:update]
  def create

  end
  def update
    if params[:user_id]
      @author=User.find(params[:user_id])
    elsif params[:broker_id]
      @author=Broker.find(params[:broker_id])
    end
    if params[:direction]=="up"
      @vote=@author.votes.new(financial_story_id:@story.id,description:"up")
    else
      @vote=@author.votes.new(financial_story_id:@story.id,description:"down")
    end 
    respond_to do |format|
      if @vote.save
        if params[:direction]=="up"
          @story.votes=@story.votes+1
        else
          @story.votes=@story.votes-1
        end
        @story.save
        format.html{redirect_to @story}
        format.js{}
      else
        format.js{}
      end
    end
  end
  def edit
  end
  def show
    @vote=Vote.new
  end
  def destroy
  end
  def index
  end
  private
  def set_story
    @story=FinancialStory.find(params[:id])
  end

end
