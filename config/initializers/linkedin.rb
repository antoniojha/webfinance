LINKEDIN_CONFIG = YAML.load_file("#{::Rails.root}/config/linkedin.yml")[::Rails.env]
ENV['LINKEDIN_KEY']=LINKEDIN_CONFIG['KEY'].to_s
ENV['LINKEDIN_SECRET']=LINKEDIN_CONFIG['SECRET']