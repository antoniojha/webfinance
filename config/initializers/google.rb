GOOGLE_CONFIG = YAML.load_file("#{::Rails.root}/config/google.yml")[::Rails.env]
ENV['GOOGLE_KEY']=GOOGLE_CONFIG['KEY']
ENV['GOOGLE_SECRET']=GOOGLE_CONFIG['SECRET']