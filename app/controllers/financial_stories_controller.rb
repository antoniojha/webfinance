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
    if params[:direction]=="up"
      @vote=@author.votes.new(financial_story_id:@story.id,description:"up")
    elsif params[:direction]=="down"
      @vote=@author.votes.new(financial_story_id:@story.id,description:"down")
    end 
    respond_to do |format|
      if params[:direction]
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
      else
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
