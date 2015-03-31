class SchedulesController < User::AuthenticatedController
  before_action :set_broker, only: [:new]
  def new
    @schedule=Schedule.new
    @schedules=Schedule.all

    @date=params[:month] ? Date.parse(params[:month]) : Date.today
  end
  def index

  end
  def create
    @schedule=Schedule.new(schedule_params)
    if @schedule.save
      redirect_to new_schedule_url
    else
      @date=params[:month] ? Date.parse(params[:month]) : Date.today
      render "new"
    end
  end
  private
  def set_broker
    @broker=Broker.find(session[:broker_id_schedule].to_i)
  end
  def schedule_params
    params.require(:schedule).permit(:schedule_date, :hour_begin, :hour_end)
  end
end
