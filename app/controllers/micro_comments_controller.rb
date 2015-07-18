class MicroCommentsController < ApplicationController
  before_action :set_comment, only:[:update,:edit,:destroy]
  def create
    @comment=MicroComment.new(financial_story_params)
    @story=FinancialStory.find(params[:micro_comment][:financial_story_id])
    @vote=Vote.new
    respond_to do |format|
      if @comment.save
        format.html{redirect_to @story}
        
        format.js{}
      else
        format.js{}
        format.html{render "financial_stories/show"}
      end
    end
  end
  def update
    respond_to do |format|
      @story=@comment.financial_story
      if @comment.update(financial_story_params)
        format.js{}
        format.html{redirect_to @story}      
      else
        format.js{}
        format.html{render "financial_stories/show"}
      end
    end
  end
  def destroy
   
    respond_to do |format|
      @story=@comment.financial_story
      @vote=Vote.new
      @comment.destroy

      format.html{redirect_to @story}
      format.js{}
    end    
  end
  private
  def set_comment
    @comment=MicroComment.find(params[:id])
  end
  def financial_story_params
    params.require(:micro_comment).permit(:user_id,:broker_id,:financial_story_id,:description)
  end
end
