class GoalsController < ApplicationController
  before_action :set_goal, only:[:update, :destroy]
  respond_to :html, :json, :js
  def create
    @goal=Goal.new(goal_params)
    respond_to do |format|
      if @goal.save
        @user=@goal.user
        format.html{redirect_to user_path(@user)}
        format.js
      else
        format.html{render "users/show"}
        format.js
      end
    end
  end
  def update
    @goal.update_attributes(goal_params)
    respond_with @goal    
  end
  def destroy
    
    @user=@goal.user
    @goal_id=@goal.id
    @goal.destroy
    respond_to do |format|
      format.js
      format.html{redirect_to @user}    
    end    
  end
  private
  def set_goal
    @goal = Goal.find(params[:id])
  end
  def goal_params
    params.require(:goal).permit(:description, :user_id)
  end
end
