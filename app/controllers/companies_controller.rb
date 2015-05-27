class CompaniesController < ApplicationController
  before_action :set_company, only: [:show,:update,:destroy]
  def new
    @company=Company.new
  end
  def create
    @company=Company.new(company_params)
    if @company.save
      redirect_to companies_url, notice:"Company successfully created"
    else
      redner "new"
    end
  end
  def index
    @companies=Company.all.order(name: :asc)
  end
  def edit
  end
  def update
    if @company.update(company_params)
      redirect_to companies_url, notice:"Company successfully updated"
    else
      render "edit"
    end
  end
  def show
  end
  def destroy
    @product.destroy
    redirect_to products_url, notice:"Company successfully deleted"
  end
  private
  def company_params
    params.require(:company).permit(:description, :location)
  end
  def set_company
    @company=Company.find(params[:id])
  end
end
