def log_in(user)
  set_email_auth_true(user)
  visit login_path
  fill_in "Username", with: user.username
  fill_in "Password", with: user.password
  click_button "Login"
  cookies[:auth_token]=user.auth_token
end
def set_email_auth_true(user)
  user.update_attributes(email_authen:true)
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