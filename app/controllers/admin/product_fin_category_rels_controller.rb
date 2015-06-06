class Admin::ProductFinCategoryRelsController < ApplicationController
  before_action :set_relation, only:[:edit,:update,:destroy]
  def new
    @product=Product.find(params[:product_id])
    @categories=@product.product_fin_category_rels
    @product_relation=ProductFinCategoryRel.new
  end
  def create
    @product_relation=ProductFinCategoryRel.new(product_relation_params)
    @product=Product.find(params[:product_fin_category_rel][:product_id])
    if @product_relation.save
      redirect_to admin_product_path(@product), notice: "New Relations has been added."
    else  
      @categories=@product.product_fin_category_rels
      render "new"
    end
  end
  def index
  end
  def edit
    @product=Product.find(@product_relation.product_id)
  end
  def update
    @product=Product.find(@product_relation.product_id)
    if @product_relation.update(product_relation_params)
      redirect_to admin_product_path(@product), notice: "Relation has been edited."
    else
      render "edit"
    end
  end
  def destroy
    @product_relation.destroy 
    @product=params[:product_id]
    redirect_to admin_product_path(@product), notice:"Product relation successfully deleted"
  end
  private
  def set_relation
    @product_relation=ProductFinCategoryRel.find(params[:id])
  end
  def product_relation_params
    params.require(:product_fin_category_rel).permit(:vehicle_type,:product_id,:description)
  end
end
