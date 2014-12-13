FactoryGirl.define do
  factory :user do
    username "testing1234"
    email  "foo@example.com"
    password "SecretPassword1?"
    password_confirmation "SecretPassword1?"
    budget_cat false
    accounts_cat false
    alarm_cat false
    social_cat false
    planning_cat false
    email_authen false
    yodlee_username "sbMemantoniojha21"
    yodlee_password "sbMemantoniojha21#123"
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
end
