class ProductFinCategoryRelsController < ApplicationController
  def new
    @product=Product.find(params[:product_id])
    @categories=@product.product_fin_category_rels
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
