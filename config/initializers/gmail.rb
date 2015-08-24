unless Rails.env =="production"
GMAIL_CONFIG = YAML.load_file("#{::Rails.root}/config/gmail.yml")[::Rails.env]
ENV['GMAIL_USERNAME']=GMAIL_CONFIG['GMAIL_USERNAME']
ENV['GMAIL_PASSWORD']=GMAIL_CONFIG['GMAIL_PASSWORD']
  
end