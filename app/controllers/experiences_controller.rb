class ExperiencesController < ApplicationController
  before_action :set_experience, only:[:edit, :update, :destroy]
  before_action :set_broker
  def create
    @experience=@broker.experiences.build(experience_params)
    respond_to do |format|
      if @experience.save
        format.js{}
        format.html{redirect_to @broker}
      else
        @error=true
        format.js{}
        format.html{render "brokers/show"}
      end
    end
  end
  def edit
    respond_to do |format|
      format.js{}
    end  
  end
  def update
    respond_to do |format|
      if @experience.update(experience_params)
        @broker.reload #this is to pick up change of any update action that happens to broker in Experience model
        format.js{}
        format.html{redirect_to @broker}
      else
        @error=true
        format.js{}
        format.html{render "brokers/show"}
      end
    end
  end

  def destroy
    @experience.destroy
    respond_to do |format|
      format.js{}
      format.html{render "brokers/show"}    
    end
  end

  private
  def set_broker
    @broker=current_broker
  end
  def set_experience
    @experience=Experience.find(params[:id])
  end
  def experience_params
    params.require(:experience).permit(:title,:company,:location,:description,:end_date,:begin_date)
  end
end
