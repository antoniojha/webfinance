class MicroCommentsController < ApplicationController
  before_action :set_comment, only:[:update,:edit,:destroy]
  def create
    @comment=MicroComment.new(financial_story_params)
    if params[:micro_comment][:financial_story_id]
      @story=FinancialStory.find(params[:micro_comment][:financial_story_id])
      story_owner=@story.broker
    elsif params[:micro_comment][:financial_testimony_id]
      @testimony=FinancialTestimony.find(params[:micro_comment][:financial_testimony_id])
      story_owner=@testimony.user
    end
    @vote=Vote.new
    respond_to do |format|
      if @comment.save
        author=trackable_author(@comment)
        track_activity @comment, author, story_owner
        if params[:micro_comment][:financial_story_id]
          format.html{redirect_to @story}
        elsif params[:micro_comment][:financial_testimony_id]
          format.html{redirect_to @testimony}
        end        
        format.js{}
      else
        format.js{}
        format.html{render "financial_stories/show"}
      end
    end
  end
  def update
    if @comment.financial_story
      @story=@comment.financial_story
    elsif @comment.financial_testimony
      @testimony=@comment.financial_testimony
    end   
    respond_to do |format|
      if @comment.update(financial_story_params)
        if @comment.financial_story
          format.html{redirect_to @story}
        elsif @comment.financial_testimony
          format.html{redirect_to @testimony}
        end
        format.js{}    
      else
        format.js{}
        if @comment.financial_story
          format.html{render "financial_stories/show"}
        elsif @comment.financial_testimony
          format.html{render "financial_testimonies/show"}
        end
        
      end
    end
  end
  def destroy
    if @comment.financial_story
      @story=@comment.financial_story
    elsif @comment.financial_testimony
      @testimony=@comment.financial_testimony
    end     
    respond_to do |format|
      
      @vote=Vote.new
      @comment.destroy
      if @comment.financial_story
        format.html{redirect_to @story}
      elsif @comment.financial_testimony
        format.html{redirect_to @testimony}
      end
      format.js{}
    end    
  end
  private
  def set_comment
    @comment=MicroComment.find(params[:id])
  end
  def financial_story_params
    params.require(:micro_comment).permit(:user_id,:broker_id,:financial_story_id,:financial_testimony_id,:description)
  end
end
