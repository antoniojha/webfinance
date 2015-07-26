class ActivitiesController < ApplicationController
  def index
    @activities=Activity.where("trackable_type=? OR trackable_type=?","FinancialTestimony","FinancialStory").order(updated_at: :desc)
  end
end
