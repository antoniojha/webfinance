class ProductFinCategoryRelsController < ApplicationController
  def new
    @product=Product.find(params[:product_id])
    @categories=@product.product_fin_category_rels
    @product_relation=ProductFinCategoryRel.new
  end
  def create
    @product_relation=ProductFinCategoryRel.new(product_relation_params)
    if @product_relation.save
      redirect_to products_url, notice: "New Relations has been added."
    else
      @product=Product.find(params[:product_id])
      @categories=@product.product_fin_category_rels
      render "new"
    end
  end
  def index
  end
  def edit
  end
  def update
  end
  def destroy
  end
  private
  def product_relation_params
    params.require(:product_fin_category_rel).permit(:vehicle_type,:product_id,:description)
  end
end
