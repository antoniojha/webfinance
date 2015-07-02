class FinancialProductsController < ApplicationController
  before_action :set_financial_product, only:[:destroy]
  def create
    @broker=Broker.find(params[:financial_product][:broker_id])
    @financial_product=FinancialProduct.where(:name=>params[:financial_product][:name], :company_id=>params[:financial_product][:company_id], :product_id=>params[:financial_product][:product_id]).first_or_create do |financial_product|
     # financial_product.description=params[:financial_product][:description]
     # financial_product.product_id=params[:financial_product][:product_id]
     # financial_product.company_id=params[:financial_product][:company_id]
    end
    
    respond_to do |format|
      
      if @financial_product.save
        @broker.financial_product_rels.create(financial_product_id:@financial_product.id)
        format.js
        format.html{redirect_to @broker}
      else
        @edit=params[:financial_product][:edit]
        format.js
        format.json { render json: @financial_product.errors, status: :unprocessable_entity }
        format.html{render "brokers/show"}
      end
    end
  end
  def index
    respond_to do |format|
      @financial_products = FinancialProduct.order(:name).where("name like ?", "%#{params[:term]}%")
      format.json do
        render json: @financial_products.map(&:name).uniq!
      end
    end
  end
  def destroy
    @broker=Broker.find(params[:broker_id])
    @financial_product_rel=FinancialProductRel.where(broker_id:@broker.id,financial_product_id:params[:id])
    @financial_product_rel.first.destroy
    
    respond_to do |format|
      format.js
      format.html{render "brokers/show"}    
    end
  end
  private
  def financial_product_params
    params.require(:financial_product).permit(:name, :description, :company_id)
  end
  def set_financial_product
    @financial_product=FinancialProduct.find(params[:id])
    
  end
end
