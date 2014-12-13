def log_in(user)
  set_email_auth(user)
  visit login_path
  fill_in "Username", with: user.username
  fill_in "Password", with: user.password
  click_button "Login"
  cookies[:auth_token]=user.auth_token
end
def set_email_auth(user)
  user.update_attributes(email_authen:'true')
end