class ProductFinCategoryRelsController < ApplicationController
  def new
    @category= "Retirement"
    @product_relation=ProductFinCategoryRel.new
  end
  def create
    
  end
  def index
  end
  def edit
  end
  def update
  end
  def destroy
  end
end
