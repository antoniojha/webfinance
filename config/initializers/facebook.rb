FACEBOOK_CONFIG = YAML.load_file("#{::Rails.root}/config/facebook.yml")[::Rails.env]
ENV['FACEBOOK_KEY']=FACEBOOK_CONFIG['KEY'].to_s
ENV['FACEBOOK_SECRET']=FACEBOOK_CONFIG['SECRET']