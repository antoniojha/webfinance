class AdviceCategoriesController < ApplicationController
  def new
    @category=AdviceCategory.new
  end
  def create
    @category=AdviceCategory.new(advice_category_params)
    if @category.save
      redirect_to advice_categories_url
    else
      render "new"
    end
  end
  def index
    @categories=AdviceCategory.all
  end
  private
  def advice_category_params
    params.require(:advice_category).permit(:description)
  end
end
