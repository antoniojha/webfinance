FactoryGirl.define do
  factory :user do
    username "testing1234"
    email  "foo@example.com"
    first_name 'first_name'
    last_name 'last_name'
    password "SecretPassword1?"
    password_confirmation "SecretPassword1?"
    email_authen true
    state "NY"
    setup_completed? true
    occupation "Teacher"
    age_level "young generation"
    factory :admin do
      admin true
    end
  end
  factory :incomplete_user, class:User do
    username "testing1234_other"
    password "SecretPassword1?"
    password_confirmation "SecretPassword1?"
    email_authen false
    setup_completed? false
  end

  factory :broker do
    username "testing"
    password "SecretPassword1?"
    password_confirmation "SecretPassword1?"
    email "antoniojha@gmail.com"
    email_authen true
    first_name "Broker First Name"
    last_name "Broker Last Name"
    company_name "World Financial Group"
    company_location "39-07 Prince St, Suite 6A-3"
    title "Associate"
    setup_completed? true
 #   license_type ["Life Insurance","Series 3"]
 #   product_ids ["1","2","3"]
    
  end
  factory :complete_broker, class:Broker do
    username "testing"
    password "SecretPassword1?"
    password_confirmation "SecretPassword1?"
    email "antoniojha@gmail.com"
    email_authen true
    first_name "Broker First Name"
    last_name "Broker Last Name"
    company_name "World Financial Group"
    company_location "39-07 Prince St, Suite 6A-3"
    title "Associate"
    setup_completed? false   
  end
  factory :incomplete_broker, class:Broker do
    username "testing"
    password "SecretPassword1?"
    password_confirmation "SecretPassword1?"
    email_authen false 
    setup_completed? false
  end  

  factory :other_user, class: User do
    username "other_testing1234"
    email  "other_foo@example.com"
    first_name 'other_first_name'
    last_name 'other_last_name'
    password "other_SecretPassword1?"
    password_confirmation "other_SecretPassword1?"
    budget_cat false
    accounts_cat false
    alarm_cat false
    social_cat false
    planning_cat false
    email_authen false
    yodlee_username "sbMemantoniojha21"
    yodlee_password "sbMemantoniojha21#123"      
  end
  factory :all_users, class:User do
    sequence(:first_name){|n| "First Name#{n}"}
    sequence(:last_name){|n| "Last Name#{n}"}
    sequence(:username){|n| "Person #{n}"}
    sequence(:email){|n| "person_#{n}@example.com"}
    password "SecretPassword1?"
    password_confirmation "SecretPassword1?"
  end

  factory :background, class: Background do
    dob_string "09/18/1987"
    married "true"
    children "4"
    state "NY"
    month "1"
    year "2015"
  end

  
  factory :license, class: License do
    picture (Rails.root+"spec/fixtures/test_files/example_license.pdf").open
    license_type "1"
    license_number "123456789"
    
  end
  factory :no_picture_license, class: License do
    license_type "1"
    license_number "123456789"  
  end
  factory :doc_license, class: License do
    picture (Rails.root+"spec/fixtures/test_files/test.docx").open
    license_type "1"
    license_number "123456789"
    
  end
end
