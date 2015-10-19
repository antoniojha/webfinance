class FinancialProductsController < ApplicationController
  before_action :set_fin_product, only:[:destroy, :edit, :update]
  before_action :set_broker
  def create
    @fin_product=FinancialProduct.new(fin_product_params)
    respond_to do |format|     
      if @fin_product.save       
        format.js{}
        format.html{ redirect_to broker_path(current_broker)}
      else
        @error=true
        format.js{}
        format.html{ render "brokers/show"}
      end
    end
  end
  def edit
    respond_to do |format|
      format.js{}
    end
  end
  def update
    @fin_product.update(fin_product_params)
    respond_to do |format|
      format.html{redirect_to broker_path(current_broker)}
      format.js{}
    end    
  end
  def destroy
    @fin_product.destroy
    respond_to do |format|
      format.html{redirect_to broker_path(current_broker)}
      format.js{}
    end
  end
  private
  def set_broker
    @broker=current_broker
  end
  def set_fin_product
    @fin_product=FinancialProduct.find(params[:id])
  end
  def fin_product_params
    params.require(:financial_product).permit(:name,:description,:company_id,:product_id, :broker_id)
  end
end
