class SetupsController < ApplicationController
  
  before_action :set_user, only:[:edit,:update]
  def edit
   
  end
  def update
  #  raise "error"
    if params[:back]

      if @user.update(user_params)
        @user.prev_step
        @user.save
        redirect_to custom_edit_setup_path(@user)
      else
        render "edit"
      end  
    else     
      @user.setup_bool=true
      if (params[:submit])
        @user.goal_bool=true
      end
      if @user.update(user_params)
        
        @user.next_step
        @user.save
        if params[:submit]
          @user.update_attribute(:setup_completed?, true)
        end
        unless @user.setup_completed?
          redirect_to custom_edit_setup_path(@user)
        else
          redirect_to edit_user_path(@user)
        end
      else
        Rails.logger.info(@user.errors.inspect) 
        render "edit"
      end
    end
  end
  private
  def set_user
    @user=User.find(params[:id])
  end
  def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :income_level, :state, :occupation, {:goal => []})

  end
end
