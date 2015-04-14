class SchedulesController < User::AuthenticatedController
  before_action :set_broker, only: [:new,:create]
  def new
    @schedule=Schedule.new
    @schedules=Schedule.all

    @date=params[:month] ? Date.parse(params[:month]) : Date.today

  end
  def index

  end
  def create
    @schedule=current_user.schedules.new(schedule_params.merge(broker_id:@broker.id))
    if @schedule.save
      redirect_to new_schedule_url
    else
      @schedules=Schedule.all
      @date=params[:month] ? Date.parse(params[:month]) : Date.today
      render "new"
    end
  end
  private
  def set_broker
    @broker=schedule_broker
  end
  def schedule_params
    params.require(:schedule).permit(:date, :hours)
  end
end
