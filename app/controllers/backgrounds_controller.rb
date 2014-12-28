class BackgroundsController < ApplicationController
  before_action :set_background, only:[:show, :edit]
  def new
    @background=Background.new
    2.times do 
      @background.incomes.build
      @background.debts.build
      @background.savings.build
      @background.optional_expenses.build
    end
    4.times{@background.fixed_expenses.build}

  end
  def edit
  end
  def create
    @background=Background.new(background_params)
    @background.save
    redirect_to @background
  end
  def show
   
  end
  private
  def background_params
    params.require(:background).permit(:dob_string, :married, :children, :income, savings_attributes:[:institution_name, :description, :amount, :category],debts_attributes:[:institution_name,:description,:amount,:interest_rate],incomes_attributes:[:description, :amount, :category], fixed_expenses_attributes:[:description, :company, :amount, :transaction_date_string, :category], optional_expenses_attributes:[:description, :amount, :category])
  end
  def set_background
     @background=Background.find(params[:id])
  end
end
