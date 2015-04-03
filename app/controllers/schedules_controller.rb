class SchedulesController < User::AuthenticatedController
  include SchedulesHelper
  before_action :set_broker, only: [:new]
  
  def new
 
    @schedule=Schedule.new
    @schedules=Schedule.all

    @date=params[:month] ? Date.parse(params[:month]) : Date.current
  end
  def index

  end
  def create
    @schedule=current_user.schedules.new(schedule_params)
    if @schedule.save
      redirect_to new_schedule_url, notice: "Appointment Successfully Made"
    else
      @broker=schedule_broker
      @schedules=Schedule.all
      @date=params[:month] ? Date.parse(params[:month]) : Date.current
      render "new"
    end
  end
  private
  def set_broker
    @broker=schedule_broker
  end
  def schedule_params
    params.require(:schedule).permit(:schedule_date, :hours,:broker_id)
  end
end
