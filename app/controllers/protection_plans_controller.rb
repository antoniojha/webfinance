class ProtectionPlansController < ApplicationController
  
  include ProfilesHelper
  before_action :set_protection_plan, only: [:edit, :show]
  def new
    @background=current_month_plan
    @protection_plan=@background.protection_plans.build
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
    params.require(:protection_plan).permit(:income,:debt,:education,:mortgage,:start_year,:start_month, :end_year,:end_month)
  end
  private
  def set_protection_plan
    @protection_plan=ProtectionPlan.find(params[:id])
  end
end
