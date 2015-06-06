def user_login(user)
  visit user_login_path
  fill_in "Username", with: user.username
  fill_in "Password", with: user.password
  click_button "Login"
  
#  cookies[:auth_token]=user.auth_token
end
def broker_log_in(broker)
 # session[:broker_id]=broker.id
  
#  cookies[:auth_token]=user.auth_token
end

def create_spending(user)
  @spending=FactoryGirl.build(:spending)
  @spending.user_id=user.id
  @spending.save
  @spending
end

def background_nav_link(i)
  names=["1. Background", "2. Income","3. Fixed Expense","4. Optional Expense","5. Saving","6. Property","7. Debt"]
  names[i-1]
end