class FinancialStoriesController < ApplicationController
  before_action :set_story, only:[:show, :edit,:update,:destroy]
  before_action :set_broker
  def create
    @fin_story=@broker.financial_stories.build(financial_story_params) 
    respond_to do |format|
      if @fin_story.save
        track_activity @fin_story, @broker, nil
        format.js{}
        format.html{redirect_to @broker}
      else
        @error=true
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
      @vote=@author.votes.new(financial_story_id:@fin_story.id,description:"up")
    end 
    if params[:cancel_upvote]
      @vote=@author.votes.where(financial_story_id:@fin_story.id).first
      @vote.destroy
      @fin_story.votes=@fin_story.votes-1
      @fin_story.save
    end
    respond_to do |format|
      #this is to vote up or cancel vote by both user and broker
      if params[:upvote] || params[:cancel_upvote]
        @change_vote=true
        if params[:upvote]
          if @vote.save
            @fin_story.votes=@fin_story.votes+1
            @fin_story.save
            format.html{redirect_to @fin_story}
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
        @broker=@fin_story.broker
        @story_id=@fin_story.id
        if @fin_story.update(financial_story_params)
          format.html{redirect_to @broker}
          format.js{}
        else
          @error=true
          format.html{render "brokers/show"}
          format.js{}
        end
      end
    end
  end
  def edit
    respond_to do |format|
      format.js{}
      format.html{redirect_to @broker}
    end
  end
  def show
    @vote=Vote.new
    @edit=params[:edit]
    @author= current_user || current_broker

  end
  def destroy
    @story_id=@fin_story.id
    @fin_story.destroy
    
    respond_to do |format|
      format.js{}
      format.html{redirect_to @broker}
    end
  end
  def index
    @interest=params[:interest]
    @product=Product.find(params[:product_id])    
    @stories=@product.financial_stories.order(votes: :desc).paginate(:page => params[:page], :per_page => 10)
  end
  private
  def financial_story_params
    params.require(:financial_story).permit(:title,:financial_category,:product_id,:description)
  end
  def set_broker
    @broker=current_broker
  end
  def set_story
    @fin_story=FinancialStory.find(params[:id])
  end

end
