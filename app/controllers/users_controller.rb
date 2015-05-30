class UsersController < User::AuthenticatedController
  skip_before_action :redirect_to_user_setup, only:[:new,:edit,:create,:update,:destroy]
  skip_before_action :redirect_to_complete_user_profile, only:[:new,:edit,:create,:update,:destroy]
  skip_before_action :authorize_user_login, only: [:new,:create]
  before_action :set_user, only: [:show, :edit, :update,:home, :destroy]

  before_action :correct_user, only:[:edit,:update,:destroy]
  include ProfilesHelper

  def home
    
  end
  def index
    @users = User.order(:username).paginate(:page => params[:page])
  end

  def show
    @crop=params[:crop]
    @plan=current_month_plan
  end
  
  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        # method can be found in User model
   #     @user.send_email_confirmation
        user_log_in(@user)
        format.html { redirect_to @user}
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: users_url, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if params[:edit_goals]
        @user.goal_bool=true
      end
      if params[:send_validation]
        @user.validate_email_bool=true
        @user.evaluate_and_reset_email_authen(params[:user][:email])
      end
      if params[:validate_email]
        user=User.find_by_email_confirmation_token(params[:user][:validation_code])
        if user == @user
          @user.update_attribute(:email_authen, true)
        end
      end
      if params[:delete_picture]
        @user.picture=nil
        if @user.save
          format.html { redirect_to @user,notice:'Your profile was successfully updated.'}
        else
          render "show"
        end
      elsif @user.update(user_params)
        if params[:user][:picture].blank?
          if @user.cropping?
            @user.reprocess_picture
          end
          if @user.validate_email_bool && (@user.email_authen!=true)
            @user.send_email_confirmation
          end
          format.html { redirect_to @user,notice:'User was successfully updated.'}
          format.json { head :no_content }
        else
          format.html{
            redirect_to :controller => 'users', :action => 'show', :id => @user.id, :crop => true
          }
        end
      else
        if @user.goal_bool
          format.html { render action: 'show' }
        else
          format.html { render action: 'edit' }
        end
      end
    end
  end
  
  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    user=User.find_by(username: params[:user][:username].downcase)
    if is_admin_remove?
      remove_user=User.find(params[:remove_user][:id])
    end
    
    respond_to do |format|
      if user && user.authenticate(params[:user][:password])
        if is_admin_remove?
          name=remove_user.username 
          remove_user.destroy unless remove_user.admin?
        else
          user.destroy unless user.admin?
        end
     #   reset_session
        
        if current_user.admin?
          if is_admin_remove?
            flash[:notice]=name+"'s profile is successfully removed!"
          elsif user.admin?
            flash[:danger]="Not allowed. You can't remove the admin profile!"
          end
          format.html{redirect_to users_url}
        else
          flash[:notice]="Your profile is successfully removed!"
          format.html { redirect_to login_url}
        end
        format.json { head :no_content }
      else
        flash[:danger]="Invalid user/password combinations"
        format.html {  redirect_to remove_url}
      end
    end
  end
 
  def email_confirmation
    @user=User.find(session[:user_id])
  end
  def remove
    @user=User.find(current_user.id)
  end
  def admin_remove
    @user=User.find(current_user.id)
    @user_delete=User.find(params[:id])
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name,:username, :email, :password, :password_confirmation,:validation_code,:picture, :crop_x,:crop_y,:crop_w,:crop_h,:income_level, :state, :occupation, {:goal => []})
    end
    def correct_user
      @user=User.find(params[:id])
      unless @user== current_user
        redirect_to user_url(current_user), notice: "Access Denied"
      end
    end
  def is_admin_remove?
    params[:remove_user] ? true : false
  end
end
