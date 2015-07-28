namespace :db do
  desc "Fill customer database with brokers and users"
    task populate: :environment do
      Broker.all.each do |broker|
        AllCustomer.create!(customer:broker)
      end
      User.all.each do |user|
        AllCustomer.create!(customer:user)
      end
    end
end