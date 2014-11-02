FactoryGirl.define do
  factory :user do
    username "testing123"
    email  "foo@example.com"
    password "SecretPassword1?"
    password_confirmation "SecretPassword1?"
  end
end
