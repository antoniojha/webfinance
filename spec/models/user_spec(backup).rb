    describe "with admin attribute set to true" do
      before do
        @user.toggle!(:admin)
      end
      it {should be_admin}
    end
    #@user2 is used because it's testing validation when user is updated not created
    describe "when first name is not entered" do
      before {@user2.first_name=""}
      it "shouldn't save" do
        expect(@user2).not_to be_valid
      end
    end
    describe "when last name is not entered" do
      before {@user2.last_name=""}
      it "shouldn't save" do
        expect(@user2).not_to be_valid
      end
    end
    #check
    describe "shouldn't save when username is not entered" do
      before {@user.username=""}
      it {should_not be_valid}
    end
    #check
    describe "shouldn't save when email is not entered" do
      before {@user.email=""}
      it {should_not be_valid}
    end
    #check
    describe "shouldn't save when email is already registered" do
      before do
        @user_with_same_email=@user.dup
        @user_with_same_email.username="Different Example User"
        @user_with_same_email.save
      end
      it {should_not be_valid} 
      it "should not be valid even if email has differenct case" do
        @user.email=@user.email.capitalize
        expect(@user).not_to be_valid
      end
    end
    #check
    describe "when username is already registered" do
      before do
        @user_with_same_name=@user.dup
        @user_with_same_name.email="different_example@example.com"
        @user_with_same_name.save
      end
      it "should not be valid" do
        expect(@user).not_to be_valid 
      end
      it "should not be valid even if username has differenct case" do
        @user.username=@user.username.capitalize
        expect(@user).not_to be_valid
      end
    end
    #check
    describe "when password is different from password_confirmation" do 
      before do
        @user3=@user.dup
        @user3.password_confirmation= ""
      end 
      it "should not be valid" do
        @user3.save
        expect(@user3).not_to be_valid
      end
      it "now with the same password the user should be valid" do
        @user3.password_confirmation=@user3.password
        expect(@user3).to be_valid
      end
    end
    ####
    if false
    #check
    describe "check value of authenticate method" do
      before{@user.save}
      let(:found_user){User.find_by(email: @user.email)}
      describe "with valid password" do
        it "should return true when authenticated" do
          expect(found_user.authenticate(@user.password)).to eq @user
        end
      end
      describe "with invalid password" do
        it "should return false when authenticated" do
          expect(found_user.authenticate("invalid")).to eq false
        end
      end
    end
    #check
    describe "when password is too long" do
      before do
        @user.password="A!1"+"a"*40
        @user.password_confirmation=@user.password
      end
      it "should not be valid" do
        expect(@user).not_to be_valid
      end
    end
    #check
    describe "when password is too short" do
      before do
        @user.password="A!1a"
        @user.password_confirmation=@user.password
      end
      it "should not be valid" do
        expect(@user).not_to be_valid
      end
    end
    #check
    describe "when email address with uppercase is saved already" do
      before do
        user_with_same_email=@user.dup
        user_with_same_email.email=@user.email.upcase
        user_with_same_email.save
      end
      it  {should_not be_valid}
    end
    #check
    describe "when email format is valid" do
      it "should be valid" do
        addresses=%w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
        addresses.each do |valid_address|
          @user.email=valid_address
          expect(@user).to be_valid
        end
      end
    end
    #check
    describe "when email format is invalid" do
      it "should be invalid" do
        addresses=%w[user.foo,com user_at_foo.org example.user@foo. foo@bar_baz.com  foo@baz+baz.com]
        addresses.each do |invalid_address|
          @user.email=invalid_address
          expect(@user).not_to be_valid
        end
      end
    end
    # check
    describe "when password format is invalid" do
      it "should be invalid" do
        passwords=%w[aaaaaa1 aaaaaaA AAAAAA1]
        passwords.each do |invalid_address|
          @user.password=invalid_address
          @user.password_confirmation=invalid_address
          expect(@user).not_to be_valid
        end
      end
    end
  end

  describe "#send confirmation_password" do
    let(:user){FactoryGirl.create(:user)}
    #check
    it "generates email autentication each time" do
      user.send_email_confirmation
      last_token=user.email_confirmation_token
      expect(user.email_confirmation_token).not_to eq nil
      user.send_email_confirmation
      expect(user.email_confirmation_token).not_to eq(last_token)
    end
    #check
    it "saves the time email confirmation was sent" do
      user.send_email_confirmation
      expect(user.reload.email_confirmation_sent_at).to be_present
    end
    #check
    it "should send email to user" do
      user.send_email_confirmation
      expect(last_email.to).to include (user.email)
    end 
    #check
    it "authenticated? it should return false for a user with nil auth_token digest" do
      expect(user.authenticated?('')).to eq false
      user.remember
      expect(user.authenticated?(user.auth_token)).to eq true
    end

  end
  describe "#address_changed? method" do

    it "address, longitude, latitude should be populated" do
      expect(@user2.address).to be_present
      expect(@user2.longitude).to be_present
      expect(@user2.latitude).to be_present
    end
    it "should call geocode if address is updated" do
      @latitude=@user2.latitude
      @longitude=@user2.longitude
      result=@user2.update(street:"61-29 223 Place",city:"Oakland Gardens",state:"New York")
      expect(result).to eq true
      @user2=@user2.reload
      expect(@longitude).not_to eq @user2.longitude
      expect(@latitude).not_to eq @user2.latitude
    end
    it "shouldn't call geocode is address is the same" do
      @latitude=@user2.latitude
      @longitude=@user2.longitude
      result=@user2.update(street:"80-75 208 Street")
      expect(result).to eq true
      @user2=@user2.reload
      expect(@longitude).to eq @user2.longitude
      expect(@latitude).to eq @user2.latitude       
    end
  end
