class ProductsController < ApplicationController
  # this controller creates financial vehicles but naming it as vehiclecontroller is a little bit awkward so it's named product instead.
  include SessionsHelper
  before_action :set_product, only:[:show,:update,:destroy,:edit]
  before_action :authorize_admin
  def new
    @product=Product.new
  end
  def create
    @product=Product.new(product_params)
    if @product.save
      redirect_to products_url, notice: "Vehicle successfully created"
    else
      render "new"
    end
  end
  def show
    @categories=@product.product_fin_category_rels
  end
  def update
    if @product.update(product_params)
      redirect_to products_url, notice:"Vehicle successfully updated"
    else
      render "new"
    end
  end
  def destroy
    @product.destroy
    redirect_to products_url, notice:"Vehicle successfully deleted"
  end
  def edit
  end
  def index
    @category=params[:vehicle_type]
    @products=Product.all.order(name: :asc)
    @products_cat=Product.where(vehicle_type:@category)
    @sec_products_cat=ProductFinCategoryRel.where(vehicle_type:@category)
  end
  private
  def product_params
    params.require(:product).permit(:name,:description,:vehicle_type,:risk_level)
  end
  def set_product
    @product=Product.find(params[:id])
  end
  def authorize_admin
    
    unless ((current_user.nil? == false) && (current_user.admin == true))
      redirect_to user_login_url, notice: "Access Denied!"
    end
  end
end
