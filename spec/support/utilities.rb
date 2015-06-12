def user_login(user)
  visit user_login_path
  fill_in "Username", with: user.username
  fill_in "Password", with: user.password
  click_button "Login"
  
#  cookies[:auth_token]=user.auth_token
end
#creates an instance of broker application request, create two licenses and two license requests
def setup_broker_requests(broker)
    
    @setup_broker=broker.build_setup_broker
    @setup_broker.save
    broker.license_type.each_with_index do |l,index| 
      license=@setup_broker.licenses.create(license_type:l,license_number:"test#{index}")
      license.picture=(Rails.root+"spec/fixtures/pdfs/example_license.pdf").open
      license.save
    end
    @license1=License.all.first
    @license2=License.all.second
    broker.broker_requests.create(request_type:"create account",complement:false)  
    broker.reload
    broker.setup_broker.licenses.each do |l|
      broker.broker_requests.create(request_type:"create license", license_id:l.id,complement:true,admin_reply:nil)
    end
end
def broker_login(broker)
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

 def full_name(person)
   name=person.first_name.capitalize+ " "+person.last_name.capitalize
   return name
 end