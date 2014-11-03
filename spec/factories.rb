FactoryGirl.define do
  factory :user do
    username "testing1234"
    email  "foo@example.com"
    password "SecretPassword1?"
    password_confirmation "SecretPassword1?"
  end
end
