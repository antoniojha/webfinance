class SchedulesController < User::AuthenticatedController
  before_action :set_broker, only: [:new, :create]
  include SessionsHelper
  
  def new
    @schedule=Schedule.new
    @schedules=Schedule.all
    @date=params[:month] ? Date.parse(params[:month]) : Date.current
  end
  def index

  end
  def create
    current_user=User.find_by(params[:user_id])
  
    if Schedule.create(schedule_params.merge(params[:user_id]))
      redirect_to new_schedule_url, notice: "Appointment Successfully Made"
    else
      @schedules=Schedule.all
      @date=params[:month] ? Date.parse(params[:month]) : Date.current
      render "new"
    end
  end
  private
  def set_broker
  #  @broker=schedule_broker
    @broker=Broker.find_by(id:session[:broker_id_schedule])
  end
  def schedule_params
    params.require(:schedule).permit(:schedule_date, :hours,:broker_id,:user_id)
  end
end
