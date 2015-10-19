class EducationsController < ApplicationController
  before_action :set_education, only:[:update,:destroy, :edit]
  before_action :set_broker

  def create
    @education=@broker.educations.build(education_params)
    
    respond_to do |format|
      if @education.save
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
      if @education.update(education_params)
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
    @education.destroy
    respond_to do |format|
      format.js
      format.html{render "brokers/show"}    
    end
  end

  private
  def set_broker
    @broker=current_broker
  end
  def set_education
    @education=Education.find(params[:id])
  end
  def education_params
    params.require(:education).permit(:school,:degree,:honors,:description,:end_date,:begin_date)
  end
end
