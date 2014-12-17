namespace :db do
  desc "Fill database with users"
    task populate: :environment do
      User.create!(
        username:"Example User",
        email:"example@example.com",
        password:"fooBar12??",
        password_confirmation:"fooBar12??"
      )
      99.times do |n|
        username=Faker::Name.name
        first_name=username
        email="example#{n+1}@example.com"
        password='fooBar12??'
        User.create!(username:username,email:email,first_name:first_name,password:password,password_confirmation:password)
      end
    end
end
