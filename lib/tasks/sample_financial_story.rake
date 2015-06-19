namespace :db do
  desc "Fill database with financial stories"
    task populate: :environment do
      Product.all.each_with_index do |product,index|
        n=0
        5.times do
          n=n+1
          b=Random.new.rand(Broker.all.count)
          broker=Broker.all[b-1]
          FinancialStory.create(product_id:product.id,broker_id:broker.id, description:"description #{index},#{n}",financial_category:"1")
        end
      end
    end
end