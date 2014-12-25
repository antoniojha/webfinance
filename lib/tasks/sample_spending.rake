namespace :db do
  desc "Fill database with users"
    task populate: :environment do
      Spending.create!(
        transaction_date_string:'12/20/14',
        description: "example",
        category: 1,
        amount: 100,
        user_id: 1
      )
      99.times do |n|
        transaction_date_string='12/20/14'
        description="test#{n+1}"
        category=1
        amount=100
        user_id=104
        Spending.create!(transaction_date_string:transaction_date_string,description:description,category:category,amount:amount,user_id:user_id)
      end
    end
end