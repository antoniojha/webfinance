class SchedulesController < User::AuthenticatedController
  
  before_action :set_broker, only: [:new,:create]
  
  def new
    @schedule=Schedule.new
    @schedules=Schedule.all

    @date=params[:month] ? Date.parse(params[:month]) : Date.current
  end
  def index

  end
  def create
    @schedule=current_user.schedules.new(schedule_params.merge(broker_id: @broker.id))
    if @schedule.save
        redirect_to new_schedule_url, notice: "Appointment Successfully Made"

    else
      @broker=Broker.find(session[:broker_id_schedule])
      @schedules=Schedule.all
      @date=params[:month] ? Date.parse(params[:month]) : Date.current
      render "new"
    end
  end
  private
  def set_broker
    @broker=Broker.find(session[:broker_id_schedule])
  end
  def schedule_params
    params.require(:schedule).permit(:date, :hours)
  end
end
