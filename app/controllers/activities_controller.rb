class ActivitiesController < ApplicationController
  before_action :set_activity, only: [:destroy]
  def index
    @activities=Activity.where("trackable_type=? OR trackable_type=?","FinancialTestimony","FinancialStory").order(updated_at: :desc)
  end
  def destroy
    @activity.destroy
    respond_to do |format|
      format.js
      if broker_logged_in?
        format.html{redirect_to current_broker}    
      elsif user_logged_in?
        format.html{redirect_to current_user}  
      end
    end
  end
  private
  
  def set_activity
    @activity=Activity.find(params[:id])
  end
end
