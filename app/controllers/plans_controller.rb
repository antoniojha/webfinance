class PlansController < ApplicationController

 
  def new
    
  end
  def start
    respond_to do |format|
      if params[:category]
        plan_urls=[protection_plans_url, debt_2_url, emergency_3_url, retirement_4_url, education_5_url, saving_6_url]
        plan_url=plan_urls[params[:category].to_i-1]
        format.html{redirect_to plan_url}
      else
        format.html{render "new"}
      end
    end
  end
  def create
  end
  def protection_1

  end
  def debt_2
  end
  def emergency_3
  end
  def retirement_4
  end
  def education_5
  end
  def saving_6
  end
  def create
    if params[:name]=="protection_1"
      @plan_1=current_month_plan.protection_plans.build(protection_params)

    end
    respond_to do |format|
      if @plan_1.save
        format.html{redirect_to @plan}
      else
        render "protection_1"
      end
    end
  end
  def plan_params
    params.require(:plan).permit(:category,:description,:start_date, :maturity_date, :start_amount, :goal_amount, :monthly_cost, :monthly_return,:interest_rate)
  end
  def protection_params
    params.require(:protection_plan).permit(:debt, :income,:mortgage,:education)
  end

end
