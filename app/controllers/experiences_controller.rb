class ExperiencesController < ApplicationController
  before_action :set_experience, only:[:update, :destroy]
  def new
  end
  def create
    @broker=Broker.find(params[:experience][:broker_id])
    @experience=@broker.experiences.build(experience_params)
    respond_to do |format|
      if @experience.save
        format.js
        format.html{redirect_to @broker}
      else
        format.js
        format.html{render "brokers/show"}
      end
    end
  end
  def edit
  end
  def update
    @broker=Broker.find(params[:experience][:broker_id])
    respond_to do |format|
      if @experience.update(experience_params)
        @broker.reload #this is to pick up change of any update action that happens to broker in Experience model
        format.js
        format.html{redirect_to @broker}
      else

        format.js
        format.html{render "brokers/show"}
      end
    end
  end
  def index
  end
  def destroy
    @experience.destroy
    @broker=Broker.find(params[:broker_id])
    respond_to do |format|
      format.js
      format.html{render "brokers/show"}    
    end
  end
  def show
  end
  private
  def set_experience
    @experience=Experience.find(params[:id])
  end
  def experience_params
    params.require(:experience).permit(:title,:company,:location,:description,:end_date,:begin_date)
  end
end
