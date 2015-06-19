if false
namespace :db do
  desc "Fill database with brokers"
    task populate: :environment do
      50.times do |n|
        name=Faker::Name.name
        first_name=name.split[0]
        last_name=name.split[1]
        company_name=Faker::Company.name

        street="street#{n}"
        city= "city#{n}"
        state="NY"
        username=Faker::Internet.user_name
        email=Faker::Internet.email
        password='fooBar12??'
        phone_number_work=Faker::Number.number(10)
        phone_number_cell=Faker::Number.number(10)
        array=[]
        3.times do |n|
          r=Random.new.rand(Product.all.count)
          array<<(Product.all[r-1].id).to_s
        end
        web=Faker::Internet.url('example.com')

        Broker.create!(first_name:first_name, last_name:last_name,company_name:company_name,street:street,city:city,state:state,username:username,email:email,password:password,password_confirmation:password,phone_number_work:phone_number_work,phone_number_cell:phone_number_cell, product_ids: array, web:web)
     
 
      end
    end
end
end