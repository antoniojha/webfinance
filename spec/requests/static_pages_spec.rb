
require 'rails_helper'

describe "StaticPages" do
  subject {page}
  describe "Home page" do
    before {visit root_path}
    it {should have_content('Home')}
    it {should have_title("WebFinance App|Home")}
    it "should have right links" do
      expect(page).to have_link("About")
      click_link "About"
      expect(page).to have_title("WebFinance App|About")
      
      expect(page).to have_link("Contact")
      click_link "Contact"
      expect(page).to have_title("WebFinance App|Contact")
      
      expect(page).to have_link("Home")
      click_link "Home"
      expect(page).to have_title("WebFinance App|Home")
      
      expect(page).to have_link("Quick Demo")
      click_link "Quick Demo"
      expect(page).to have_title("WebFinance App|Demo")
      
      expect(page).to have_link("Blog")
      click_link "Blog"
      expect(page).to have_title("WebFinance App|Blog")
      
      expect(page).to have_link("Sign In")
      click_link "Sign In"
      expect(page).to have_content("Login")
      
      expect(page).to have_link("Sign Up")
      click_link "Sign Up"
      expect(page).to have_content("Sign Up")
    end
  end
  describe "Login page" do
    before {visit login_path}
    it {should have_content('Login')}
    it "should have right link" do
    click_link "New User?"
    expect(page).to have_content("Sign Up")
    end
  end
  describe "Demo page" do
    before {visit demo_path}
    it {should have_content('Demo')}  
    it {should have_title("WebFinance App|Demo")}   
  end
  describe "About page" do
    before {visit about_path}
    it {should have_content('About')}
    it {should have_title("WebFinance App|About")}  
  end
  describe "Contact page" do
    before {visit contact_path}
    it {should have_content('Contact')} 
    it {should have_title("WebFinance App|Contact")}  
  end
end

