require 'rails_helper'
describe "Authentication" do
  describe "authorization" do
    describe "testing user login features" do
      describe "in User controller" do
        let(:user){FactoryGirl.create(:user)}
        describe "correct sign in" do
          before do
            
            log_in(user)   
          end
          it "should allow user to access show page" do
            visit user_path(user.id)
            expect(page).to have_content(user.first_name)    
            expect(page.title).to eq ('WebFinance App|first_name')
          end
          it "should allow user to access edit page" do
            visit edit_user_path(user.id)
            expect(page).to have_content('Update Profile')
          end
          
        end
        describe "without sign in" do
          describe "in User Controller" do
            it "should redirect index to signin" do
              visit users_path
              expect(page).to have_title('WebFinance App|Login')
              expect(page).to have_content('Login')
            end
            it "should redirect edit to signin" do
              visit edit_user_path(user)
              expect(page).to have_content('Login')
            end
            describe "should redirect update to signin" do
              before{put user_path(user)}
              specify{response.should redirect_to(login_path)}  
            end
            describe "should friendly forward to desired page-" do
              before do
                set_email_auth_true(user)
              end
              it "edit page" do
                visit edit_user_path(user)
                fill_in "Username", with: user.username
                fill_in "Password", with: user.password
                click_button "Login"
                expect(page).to have_content('Update Profile')
                expect(page).to have_title('WebFinance App|Edit User')
              end
              let(:title){"WebFinance App|"+user.first_name}
              it "show page" do
                set_email_auth_true(user)
                visit user_path(user)
                fill_in "Username", with: user.username
                fill_in "Password", with: user.password
                click_button "Login"
                expect(page).to have_content(user.first_name)
                expect(page).to have_title(title)
              end
            end
          end
        end
      end
      
    end
    describe "testing correct_user features" do
      
      let(:user){FactoryGirl.create(:user)}
      let(:wrong_user){FactoryGirl.create(:other_user)}
      before do
        log_in user
      end
      describe "as wrong user" do
        describe "should access edit if correct user" do
          before{visit edit_user_path(user)}
          it "visit Users#edit page" do
            expect(page).not_to have_content("Access Denied")
            expect(page).to have_content("Update Profile")
          end
        end
        describe "should redirect show when it's incorrect user" do
          before {visit user_path(wrong_user)}
          
          let(:str){"WebFinance App|"+user.first_name}
          
          it "visit Users#show page" do
            expect(page).to have_content("Access Denied")
            expect(page).to have_title(str)
          end  
        end      
        describe "should redirect edit when it's incorrect user" do
          before {visit edit_user_path(wrong_user)}
          
          let(:str){"WebFinance App|"+user.first_name}
          
          it "visit Users#show page" do
            expect(page).to have_content("Access Denied")
            expect(page).to have_title(str)
          end  
        end   
      end
      describe "test update" do
        before do
          post signin_path, session:{username: user.username, password: user.password}
         # session[:user_id]=user.id
          cookies[:auth_token] = user.auth_token
        end
        describe "should redirect update when it's incorrect user" do
          before {put user_path(wrong_user)}
          specify{response.should redirect_to user_path(user)}
        end
        describe "should redirect delete when it's incorrect user" do
          before {delete user_path(wrong_user)}
          specify{response.should redirect_to user_path(user)}          
        end
      end
    end   
  end
end