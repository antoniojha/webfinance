
namespace :db do
  desc "Fill database with users"
    task populate: :environment do
      admin=User.create!(
        username:"antoniojha",
        email:"antoniojha@gmail.com",
        password:"6004Aj??",
        password_confirmation:"6004Aj??",
        email_authen: true,
        admin: true
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
