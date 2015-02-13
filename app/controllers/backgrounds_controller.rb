class BackgroundsController < ApplicationController
  include BackgroundsHelper
  
  before_action :set_background, only:[:show, :edit, :update, :add_assoc, :direct_to,:destroy]
  def new
    @background=Background.new
    start_step_session(@background)
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
    if params[:step]
      i=params[:step]
      @background.skip_to_step(i)
      @background.save
    end
    update_step_session(@background)
    current_field=@background.current_field
    assoc_field=current_field[0..-3]+"s"
    build_after_redirect(assoc_field)

  end
  def create
    user=current_user #from sessions_helper.rb
   
    @background=user.backgrounds.build(background_params)
    @background.month=Time.zone.today.month
    @background.year=Time.zone.today.year

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
        # doesn't display error if validation fails
        format.html{redirect_to edit_background_url(@background)}
      elsif params[:finish_button]
      
        @background.is_complete
        if @background.update(background_params)      
          end_step_session
          format.html{redirect_to @background, notice:"Successfully completed uploading personal info!"}
        else
          build_before_render(assoc_field)
          format.html{render "edit"}
        end
      elsif params[:save]
        if @background.update(background_params)
          format.html{redirect_to edit_background_url(@background)}
        else
          format.html{render "edit"}
        end
      elsif params[:protection]
        if @background.update(background_params)
          format.html{redirect_to brokers_url}
        else
          format.html{render new_protection_plan_path}
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
  def index
    @backgrounds=current_user.backgrounds
  end
  def destroy
    @background.delete
    respond_to do |format|
      format.html{redirect_to current_user, notice: "Background of this month was succesfully deleted"}
    end
  end
  private
  def background_params
    params.require(:background).permit(:state, :dob_string, :married, :children, :income,{:protection_search => []},:other_debt, :income_need, :total_mortgage, :total_education, savings_attributes:[:institution_name, :description, :amount, :category,:_destroy,:id],incomes_attributes:[:description, :amount, :category,:_destroy,:id], fixed_expenses_attributes:[:description, :company, :amount, :transaction_date_string, :category,:_destroy,:id], optional_expenses_attributes:[:description, :amount, :category,:_destroy,:id], propertees_attributes:[:description,:amount,:category,:_destroy,:id],debts_attributes:[:institution_name,:description,:amount,:interest_rate,:category,:_destroy,:id],education_expenses_attributes:[:age,:education_cost,:description,:id])
  end
  def set_background
    @background=Background.find(params[:id])
  end
  def track_association_number
    name=params[:name] unless params[:name].blank?
    @name=name
    session_names=[:saving_i, :debt_i, :income_i, :fixed_expense_i, :optional_expense_i,:property_i]
    remove_names=["remove saving","remove debt","remove income", "remove fixed_expense", "remove optional_expense","remove property"]

    add_i=add_names.index(name)
    remove_i=remove_names.index(name)
    if add_i
      @remove_name=remove_names[add_i]
      session[session_names[add_i]]+=1
      return session[session_names[add_i]]
    end
    if remove_i
      return session[session_names[remove_i]]-=1
    end
  end
  def add_names
    ["Add Saving", "Add Debt", "Add Income", "Add Fixed Expense", "Add Optional Expense", "Add Property"]
  end
  def get_assoc
    session_assocs=["saving", "debt","income","fixed_expense", "optional_expense", "property"]
    name=params[:name] unless params[:name].blank?  
    @name=name
    add_i=add_names.index(name)
    if add_i
      return session[:assoc]=session_assocs[add_i]
    end
  end
  def build_before_render(assoc_field)
    unless assoc_field=="education_expenses"
    @background.send(assoc_field).build 
session[:saving_i]=session[:debt_i]=session[:income_i]=session[:optional_expense_i]=session[:fixed_expense_i]=session[:property_i]=@background.send(assoc_field).length 
    # length method gives number of associated object that has not been saved
    end
  end
  def build_after_redirect(assoc_field)
    # called just in case if the a particular associated field does not have any object created. This ensures that it will create the default amount of associated object.
    unless assoc_field=="backgrounds"  
      if assoc_field=="education_expenses"
        # education expense field doesn't have add or remove field feature
        num=@background.children
        diff=num-@background.education_expenses.count
        diff.times{
          @background.send(assoc_field).build
        }
        if num ==0
          @no_education=true
        end
      else
        @background.send(assoc_field).build
      end
      if (@background.send(assoc_field).count==0)
 session[:saving_i]=session[:debt_i]=session[:income_i]=session[:optional_expense_i]=session[:property_i]=session[:fixed_expense_i]=1
        
      else       session[:saving_i]=session[:debt_i]=session[:income_i]=session[:optional_expense_i]=session[:fixed_expense_i]=session[:property_i]=@background.send(assoc_field).count
      end   
    end
  end
end
