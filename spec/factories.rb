FactoryGirl.define do
  factory :user do
    username "testing1234"
    email  "foo@example.com"
    first_name 'first_name'
    last_name 'last_name'
    password "SecretPassword1?"
    password_confirmation "SecretPassword1?"
    email_authen true
    street "80-75 208 Street"
    city "Hollis Hills"
    state "New York"
    factory :admin do
      admin true
    end
  end
  factory :incomplete_user, class:User do
    username "testing1234_other"
    password "SecretPassword1?"
    password_confirmation "SecretPassword1?"
    email_authen false
    street "80-75 208 Street"
    city "Hollis Hills"
    state "New York"
  end
  factory :broker, class: Broker do
    first_name "Broker First Name"
    last_name "Broker Last Name"
    email "example@example.com"
    institution_name "World Financial Group"
    street "39-07 Prince St, Suite 6A-3"
    city "Flushing"
    state "NY"
    phone_work_1 "718"
    phone_work_2 "753"
    phone_work_3 "2309"
    username "testing"
    password "SecretPassword1?"
    password_confirmation "SecretPassword1?"
    license_type ["1","2"]
    identification (Rails.root+"spec/fixtures/pdfs/example_license.pdf").open
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
  factory :bank, class: Bank do 
    id 13041
    content_service_id 3190
    content_service_display_name '1st Bank (US)'
    site_id 3048
    site_display_name '1st Bank (US)'
    mfa 'none'
    home_url 'http://www.efirstbank.com/'
    container 'bank'
  end
  factory :chasebank, class: Bank do 
    id 13061
    content_service_id 663
    content_service_display_name 'Chase (US) - Bank'
    site_id 643
    site_display_name 'Chase (US)'
    mfa 'none'
    home_url 'http://www.chase.com/'
    container 'bank'
  end
  factory :spending do
    transaction_date_string "2014-12-16"
    description "Lunch"
    amount "100"
    category "1"
    picture (Rails.root+"spec/fixtures/images/Ruby_on_Rails.jpg").open
  end
  factory :background, class: Background do
    dob_string "09/18/1987"
    married "true"
    children "4"
    state "NY"
    month "1"
    year "2015"
  end
  factory :saving, class: Saving do
    institution_name "Chase"
    description "checking"
    amount "1000"
    category "1"
    association :background
  end
  factory :debt, class: Debt do
    institution_name "Student Loan"
    description "loan"
    amount "1000"
    interest_rate "10"
    category "1"
    association :background
  end
  factory :income, class: Income do
    description "DEP"
    amount "1000"
    category "1"
    association :background
  end
  factory :fixed_expense, class: FixedExpense do
    description "mortgage"
    amount "1000"
    company "Pennymac"
    transaction_date_string "01/02/2015"
    category "1"
    association :background
  end
  factory :optional_expense, class: OptionalExpense do
    description "movies"
    amount "100"
    category "1"
  end
  factory :propertee, class: Propertee do
    description "house"
    amount "10000"
    category "1"
  end
  
  factory :license, class: License do
    picture (Rails.root+"spec/fixtures/pdfs/example_license.pdf").open
    license_type "1"
    license_number "123456789"
    
  end
  factory :no_picture_license, class: License do
    license_type "1"
    license_number "123456789"  
  end
  factory :doc_license, class: License do
    picture (Rails.root+"spec/fixtures/pdfs/test.docx").open
    license_type "1"
    license_number "123456789"
    
  end
end
