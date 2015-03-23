namespace :db do
  desc "Fill database with users"
    task populate: :environment do
      index=1
      50.times do |n|
        name=Faker::Company.name
        web=Faker::Internet.url('example.com')
        description= Faker::Lorem.paragraph(2)
        product_types=[]
        i=1
        4.times do
          num=Random.new.rand(0..1)
          if (num==1)
            product_types << i.to_s
          end
          i=i+1
        end
        if product_types.blank?
          product_types=["1"]
        end
        business_types=[]
        i=1
        4.times do
          num=Random.new.rand(0..1)
          if (num==1)
            business_types << i.to_s
          end
          i=i+1
        end
        if business_types.blank?
          business_types=["1"]
        end
        firm=Firm.create!(name:name, description:description, web:web, business_types:business_types,product_types:product_types )
        
        num=Random.new.rand(0..10)
        index=0
        num.times do
          i=index%product_types.length
          product_type=product_types[i].to_i
          name=Faker::Commerce.product_name
          description= Faker::Lorem.paragraph(2)
          Product.create(name:name, description:description, product_type:product_type,firm_id:firm.id)
          index=index+1
        end
      end
    end
end