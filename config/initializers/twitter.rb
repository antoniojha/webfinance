if File.exists?("#{Rails.root}/config/twitter.yml")
  TWITTER_CONFIG = YAML.load_file("#{::Rails.root}/config/twitter.yml")[::Rails.env]
  ENV['TWITTER_KEY']=TWITTER_CONFIG['KEY']
  ENV['TWITTER_SECRET']=TWITTER_CONFIG['SECRET']
end