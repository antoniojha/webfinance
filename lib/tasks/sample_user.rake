if false
namespace :db do
  desc "Fill database with users"
    task populate: :environment do
      User.each(&:delete_all)
      admin=User.create!(
        first_name:"Antonio",
        last_name:"Jha",
        username:"antoniojha",
        email:"antoniojha@gmail.com",
        password:"6004Aj??",
        password_confirmation:"6004Aj??",
        email_authen: true,
        admin: true
      )
      99.times do |n|
        name=Faker::Name.name
        first_name=name.split[0]
        last_name=name.split[1]
        username=Faker::Name.name
        first_name=username
        email="example#{n+1}@example.com"
        password='fooBar12??'
        User.create!(first_name:firstname, last_name:lastname,username:username,email:email,password:password,password_confirmation:password)
      end
    end
end
end
