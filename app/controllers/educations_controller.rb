class EducationsController < ApplicationController
  def new
  end
  def create
    @broker=Broker.find(params[:education][:broker_id])
    @education=@broker.educations.build(education_params)
    respond_to do |format|
      if @education.save
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
  end
  def index
  end
  def destroy
  end
  def show
  end
  private
  def education_params
    params.require(:education).permit(:school,:degree,:honors,:description,:end_date,:begin_date)
  end
end
