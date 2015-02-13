class ProtectionPlansController < ApplicationController
  
  include ProfilesHelper
  before_action :set_protection_plan, only: [:edit, :show]
  def index
    @background=current_month_plan
    @protection_plan=ProtectionPlan.new
    if @background.nil?
      redirect_to new_background_url, notice: "Please first create a financial profile."
    end  
  end
  def new

  end
  def edit
    
  end
  def create
    @background=current_month_plan
    @protection_plan=@background.protection_plans.build(protection_plan_params)
    if @protection_plan.save
      redirect_to @protection_plan
    else
      render "new"
    end
  end
  def show
  end
  def protection_plan_params
    params.require(:protection_plan).permit(:protection_need)
  end
  private
  def set_protection_plan
    @protection_plan=ProtectionPlan.find(params[:id])
  end
end
