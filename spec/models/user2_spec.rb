require 'rails_helper'
describe User do
  describe "#address_changed? method" do
    #let(:user){FactoryGirl.create(:user)}
    before do 
      @user=User.create(username:"example user2", email:"example2@example.com",password:"Example_password12?",password_confirmation:"Example_password12?", street:"80-75 208 Street", city:"Hollis Hills", state:"NY")
    end
    it "address, longitude, latitude should be populated" do
      expect(@user.address).to be_present
      expect(@user.longitude).to be_present
      expect(@user.latitude).to be_present
    end
    it "should call geocode if address is updated" do
      @latitude=@user.latitude
      @longitude=@user.longitude
      result=@user.update(street:"61-29 223 Place",city:"Oakland Gardens",state:"New York")
      expect(result).to eq true
      @user=@user.reload
      expect(@longitude).not_to eq @user.longitude
      expect(@latitude).not_to eq @user.latitude
    end
    it "shouldn't call geocode is address is the same" do
            @latitude=@user.latitude
      @longitude=@user.longitude
      result=@user.update(street:"80-75 208 Street")
      expect(result).to eq true
      @user=@user.reload
      expect(@longitude).to eq @user.longitude
      expect(@latitude).to eq @user.latitude       
    end
  end
end