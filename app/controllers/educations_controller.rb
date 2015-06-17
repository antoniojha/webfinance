class EducationsController < ApplicationController
  before_action :set_education, only:[:update,:destroy]

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
        @edit=params[:education][:edit]
        format.js
        format.json { render json: @education.errors, status: :unprocessable_entity }
        format.html{render "brokers/show"}
      end
    end
  end
  def edit
  end
  def update
    @broker=Broker.find(params[:education][:broker_id])
    respond_to do |format|
      if @education.update(education_params)
        format.js
        format.html{redirect_to @broker}
      else
        @edit=params[:education][:edit] 
        format.js
        format.html{render "brokers/show"}
      end
    end
  end
  def index
  end
  def destroy
    @education.destroy
    @broker=Broker.find(params[:broker_id])
    respond_to do |format|
      format.js
      format.html{render "brokers/show"}    
    end
  end
  def show
  end
  private

  def set_education
    @education=Education.find(params[:id])
  end
  def education_params
    params.require(:education).permit(:school,:degree,:honors,:description,:end_date,:begin_date)
  end
end
