class BackgroundsController < ApplicationController
  before_action :set_background, only:[:show, :edit, :update, :add_assoc]
  def new
    @background=Background.new
    
    respond_to do |format|
      format.html
      format.js
    end
  end
  def add_assoc
    @test=params[:name]
    @assoc=get_assoc
    @assoc_num=track_association_number
    build_name=@assoc+"s"
    if (@assoc_num)==1
      @background.send(build_name).build
    end
    respond_to do |format|
      format.html{render 'new'}
      format.js
    end
  end
  def remove_assoc
    @assoc_num=track_association_number
    respond_to do |format|
      format.html{render 'new'}
      format.js
    end    
  end
  def edit
    current_field=@background.current_field
    assoc_field=current_field[0..-3]+"s"
    build_after_redirect(assoc_field)

  end
  def create
    @background=Background.new(background_params)
    respond_to do |format|
      @background.next_step
      if @background.save
        format.html{redirect_to edit_background_url(@background)}
      else
        @background.prev_step
        format.html{render 'new'}
      end
    end
  end
  def update
    current_field=@background.current_field
    assoc_field=current_field[0..-3]+"s"
    respond_to do |format|
      if params[:back_button]
        @background.prev_step
        @background.save
        @background.update(background_params)
        format.html{redirect_to edit_background_url(@background)}
      elsif params[:finish_button]
        if @background.update(background_params)
          format.html{redirect_to @background, notice:"Successfully completed uploading personal info!"}
        else
          build_before_render(assoc_field)
          format.html{render "edit"}
        end
      else
        @background.next_step
        if @background.update(background_params) 
          format.html{redirect_to edit_background_url(@background)}     
        else
          @background.prev_step
          build_before_render(assoc_field)
          format.html{render "edit"}
        end
      end
    end
  end
  def show
   
  end
  private
  def background_params
    params.require(:background).permit(:state, :dob_string, :married, :children, :income, savings_attributes:[:institution_name, :description, :amount, :category,:_destroy,:id],debts_attributes:[:institution_name,:description,:amount,:interest_rate,:category,:_destroy,:id],incomes_attributes:[:description, :amount, :category,:_destroy,:id], fixed_expenses_attributes:[:description, :company, :amount, :transaction_date_string, :category,:_destroy,:id], optional_expenses_attributes:[:description, :amount, :category,:_destroy,:id], propertees_attributes:[:description,:amount,:category,:id])
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
    elsif name=="Add Property"
      @remove_name="remove property"
      session[:property_i]+=1  
    elsif name=="Add Optional Expense"
      @remove_name="remove optional_expense"
      session[:optional_expense_i]+=1
    #   
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
    elsif name=="remove property"
      session[:property_i]-=1
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
    elsif name.include?"Add Property"
      session[:assoc]="property"  
    end
  end
  def build_before_render(assoc_field)
    @background.send(assoc_field).build 
session[:saving_i]=session[:debt_i]=session[:income_i]=session[:optional_expense_i]=session[:fixed_expense_i]=session[:property_i]=@background.send(assoc_field).length 
    # length method gives number of associated object that has not been saved
  end
  def build_after_redirect(assoc_field)
    # called just in case if the a particular associated field does not have any object created. This ensures that it will create the default amount of associated object.
    unless assoc_field=="backgrounds"  
      if (@background.send(assoc_field).count==0)
   session[:saving_i]=session[:debt_i]=session[:income_i]=session[:optional_expense_i]=session[:property_i]=session[:fixed_expense_i]=1

        @background.send(assoc_field).build
      else       session[:saving_i]=session[:debt_i]=session[:income_i]=session[:optional_expense_i]=session[:fixed_expense_i]=session[:property_i]=@background.send(assoc_field).count
      end   
    end
  end
end
