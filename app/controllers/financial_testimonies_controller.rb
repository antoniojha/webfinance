class FinancialTestimoniesController < ApplicationController
  before_action :set_testimony, only:[:show,:update,:destroy]
  def create
    @user=User.find(params[:user_id])
    @testimony=FinancialTestimony.new(financial_testimony_params)
    @testimony.user_id=@user.id
    
    respond_to do |format|
      if @testimony.save
        format.js{}
        format.html{redirect_to @user}
      else
        @testimony_error=true
        format.js{}
        format.html{render "users/show"}
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
      @vote=@author.votes.new(financial_testimony_id:@testimony.id,description:"up")
    end 
    if params[:cancel_upvote]
      @vote=@author.votes.where(financial_testimony_id:@testimony.id).first
      @vote.destroy
      @testimony.votes=@testimony.votes-1
      @testimony.save
    end
    respond_to do |format|
      #this is to vote up or cancel vote by both user and broker
      if params[:upvote] || params[:cancel_upvote]
        @change_vote=true
        if params[:upvote]
          if @vote.save
            @testimony.votes=@testimony.votes+1
            @testimony.save
            format.html{redirect_to @testimony}
            format.js{}
          else
            format.html{render "financial_testimonies/show"}
            format.js{}
          end
        else
          format.html{redirect_to @testimony}
          format.js{}
        end
      else
        @user=@testimony.user
        @testimony_id=@testimony.id
        respond_to do |format|
          if @testimony.update(financial_testimony_params)
            format.html{redirect_to @testimony.user}
            format.js{}
          else
            @testimony_error=true
            format.html{render "users/show"}
            format.js{}
          end 
        end
      end
    end
  end
  def show
    @vote=Vote.new
    @edit=params[:edit]
    @author= current_user || current_broker
  end
  def destroy
    @user=@testimony.user
    @testimony_id=@testimony.id
    @testimony.destroy
    
    respond_to do |format|
      format.js{}
      format.html{redirect_to @user}
    end
  end
  private
  def financial_testimony_params
    params.require(:financial_testimony).permit(:title,:financial_category,:product_id,:description)
  end
  def set_testimony
    @testimony=FinancialTestimony.find(params[:id])
  end
end
