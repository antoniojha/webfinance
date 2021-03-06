class UsersController < User::AuthenticatedController
  skip_before_action :redirect_to_user_setup, only:[:new,:edit,:create,:update,:destroy]
  skip_before_action :redirect_to_complete_user_profile, only:[:new,:edit,:remove,:create,:update,:destroy, :index]
  skip_before_action :authorize_user_login, only: [:show,:new,:create,:index]
  before_action :set_user, only: [:show, :edit, :remove,:supdate,:home,:story, :destroy]

  before_action :correct_user, only:[:edit,:update,:destroy]

  def home
    unless params[:interest]
      @interest="protection"
    else
      @interest=params[:interest]
    end    
    render :template=>"shared/home"
  end

  def index
    if params[:id]
      @user_search=UserSearch.find(params[:id])
      @users=@user_search.users
      @users=@users.paginate(:page => params[:page])  
    else     
      @users=User.all.paginate(:page => params[:page])
      @user_search=UserSearch.new
    end 
  end

  def show
    unless params[:key]
      @uploader = User.new.image
      @uploader.success_action_redirect = user_url(@user)
    else
      @user.key=params[:key]
      @user.save
      @crop=true
    end
    if params[:goal_id]
      @delete_goal=Goal.find(params[:goal_id])
    end
    @edit=params[:edit]
    if params[:method]=="edit"
      @edit_testimony=FinancialTestimony.find(params[:financial_testimony_id])
 
    elsif params[:method]=="delete"
      @delete_testimony=FinancialTestimony.find(params[:financial_testimony_id])
    end
    @goal=Goal.new #needed for financial_goal_add partial template

    respond_to do |format|
      format.html
      format.js
    end
      
  end
  
  # GET /users/new
  def new
    @user = User.new
  end

  def edit
  end
  def remove
  end

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
        @user.interest_bool=true
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
        @user.image=nil
        @user.image_cropped=nil
        @user.remove_image!
        if @user.save
          format.html { redirect_to @user,notice:'Your profile was successfully updated.'}
        else
          render "show"
        end
      elsif @user.update(user_params)
        
        if params[:user][:picture].blank?
          
          if @user.cropping?
            
            @user.update_attributes(image_cropped:false)
            @user.crop_image
          end
          if @user.validate_email_bool && (@user.email_authen!=true)
        
            @user.send_email_confirmation
          end
          format.js
          format.html { redirect_to @user,notice:'User was successfully updated.'}
          format.json { head :no_content }
        else
          format.js
          format.html{
            redirect_to :controller => 'users', :action => 'show', :id => @user.id}
        end
      else
        if @user.interest_bool
          format.js
          format.html { render action: 'show' }
        else
          format.js
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
      if user && user.has_password?(params[:user][:password])
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
          format.html { redirect_to user_login_url}
        end
        format.json { head :no_content }
      else
        flash.now[:danger]="Invalid user/password combinations"
        format.html {  render "users/remove"}
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
      params.require(:user).permit(:first_name, :last_name,:username, :email, :password, :password_confirmation,:validation_code,:crop_x,:crop_y,:crop_w,:crop_h,:age_level, :state, :occupation, {:interests => []},:satisfaction, :about_statement)
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
