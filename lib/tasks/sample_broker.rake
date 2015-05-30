if false
namespace :db do
  desc "Fill database with brokers"
    task populate: :environment do
      50.times do |n|
        name=Faker::Name.name
        first_name=name.split[0]
        last_name=name.split[1]
        institution_name=Faker::Company.name

        street="80-75 208 Street"
        city= "Hollis Hills"
        state="NY"
        username=Faker::Internet.user_name
        email=Faker::Internet.email
        password='fooBar12??'
        phone_work_1="888"
        phone_work_2="888"
        phone_work_3="8888"
        num1=Random.new.rand(0..1)
        num2=Random.new.rand(0..1)
        num3=Random.new.rand(0..1)
        num4=Random.new.rand(0..1)
        l1= (num1==1) ? "1":nil
        l2= (num2==1) ? "2":nil
        l3= (num3==1) ? "3":nil
        l4= (num4==1) ? "4":nil
        license_type=[]
        [l1,l2,l3,l4].each do |num|
          if num
            license_type << num
          end
        end
        if license_type.blank?
          license_type=["1"]
        end
        web=Faker::Internet.url('example.com')
        num5=Random.new.rand(0..2).round
        if num5 ==0
          time_zone= "Pacific Time (US & Canada)"
        elsif num5==1
          time_zone= "Central Time (US & Canada)"
        elsif num5==2
          time_zone= "Eastern Time (US & Canada)"
        end
        broker=Broker.new(first_name:first_name, last_name:last_name,institution_name:institution_name,street:street,city:city,state:state,username:username,email:email,password:password,password_confirmation:password,phone_work_1:phone_work_1,phone_work_2:phone_work_2,phone_work_3:phone_work_3, license_type: license_type, web:web)
        broker.identification=(Rails.root+"spec/fixtures/pdfs/example_license.pdf").open
        broker.save!
        license_type.each do |l|
          license_type=l
          license_number=Faker::Number.number(10)
          picture=(Rails.root+"spec/fixtures/pdfs/example_license.pdf").open
          license=License.new(license_number:license_number,license_type:license_type, broker_id:broker.id)
          license.picture=picture
          license.save!
        end
      end
    end
end
end