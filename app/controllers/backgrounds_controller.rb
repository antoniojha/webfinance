class BackgroundsController < ApplicationController
  before_action :set_background, only:[:show, :edit, :update,:new_association]
  def new
    @background=Background.new

    2.times do 
      @background.incomes.build
      @background.debts.build
      @background.savings.build
      @background.optional_expenses.build
      
    end
    4.times {@background.fixed_expenses.build}
    
    session[:saving_i]=session[:debt_i]=session[:income_i]=session[:optional_expense_i]=2
    session[:fixed_expense_i]=4
    
    respond_to do |format|
      format.html
      format.js
    end
  end
  def add_assoc

    @assoc=get_assoc
    @n=track_association_number
    respond_to do |format|
      format.html{render 'new'}
      format.js
    end
  end
  def remove_assoc
    @n=track_association_number
    respond_to do |format|
      format.html{render 'new'}
      format.js
    end    
  end
  def edit
    build_instance_assoc

  end
  def create
    @background=Background.new(background_params)
    respond_to do |format|
    
      if @background.save
        format.html{redirect_to @background}
      else
        build_instance_assoc
        format.html{render 'new'}
      end
    end
  end
  def update
    respond_to do |format| 
      if @background.update(background_params)
        format.html{redirect_to @background, notice: "Background was succesfully updated"}
      else
        format.html{render "edit"}
      end
    end
  end
  def show
   
  end
  private
  def background_params
    params.require(:background).permit(:state, :dob_string, :married, :children, :income, savings_attributes:[:institution_name, :description, :amount, :category,:_destroy,:id],debts_attributes:[:institution_name,:description,:amount,:interest_rate,:_destroy,:id],incomes_attributes:[:description, :amount, :category,:_destroy,:id], fixed_expenses_attributes:[:description, :company, :amount, :transaction_date_string, :category,:_destroy,:id], optional_expenses_attributes:[:description, :amount, :category,:_destroy,:id])
  end
  def set_background
    @background=Background.find(params[:id])
  end
  def track_association_number
    name=params[:name] unless params[:name].blank?
    @name=name
    if name=="Add Saving"
      @remove_name="remove saving"
      session[:saving_i]+=1
    elsif name=="Add Debt"
      @remove_name="remove debt"
      session[:debt_i]+=1
    elsif name=="Add Income"
      @remove_name="remove income"
      session[:income_i]+=1
    elsif name=="Add Fixed Expense"
      @remove_name="remove fixed_expense"
      session[:fixed_expense_i]+=1
    elsif name=="Add Optional Expense"
      @remove_name="remove optional_expense"
      session[:optional_expense_i]+=1
    elsif name=="remove saving"
      session[:saving_i]-=1      
    elsif name=="remove debt"
      session[:debt_i]-=1
    elsif name=="remove income"
      session[:income_i]-=1
    elsif name=="remove fixed_expense"
      session[:fixed_expense_i]-=1
    elsif name=="remove optional_expense"
      session[:optional_expense_i]-=1
    end
  end
  def get_assoc
    name=params[:name] unless params[:name].blank?
    @name=name
    if name=="Add Saving"
      session[:assoc]="saving"
    elsif name=="Add Debt"
      session[:assoc]="debt"
    elsif name=="Add Income"
      session[:assoc]="income"
    elsif name.include?"Add Fixed Expense"
      session[:assoc]="fixed_expense"
    elsif name.include?"Add Optional Expense"
      session[:assoc]="optional_expense"
    end
  end
  def build_instance_assoc
    methods=%w[incomes debts savings optional_expenses fixed_expenses]
    methods.each do |method|
      if (@background.send(method).count==0)
        @background.send(method).build
      end
    end
    session[:saving_i]=session[:debt_i]=session[:income_i]=session[:optional_expense_i]=session[:fixed_expense_i]=1
  end
end
