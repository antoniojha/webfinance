namespace :db do
  desc "Fill database with vehichles" 
    task populate: :environment do  
      
      (1..7).each do |v|
        10.times do
          vehicle_type=v.to_s
          name=Faker::Commerce.product_name
          description= Faker::Lorem.paragraph(2)
          Product.create(name:name, description:description, vehicle_type:vehicle_type)
        end
      end
    end
end