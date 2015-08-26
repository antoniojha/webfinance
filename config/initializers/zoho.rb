unless Rails.env =="production"
ZOHO_CONFIG = YAML.load_file("#{::Rails.root}/config/zoho.yml")[::Rails.env]
ENV['ZOHO_USERNAME']=ZOHO_CONFIG['ZOHO_USERNAME']
ENV['ZOHO_PASSWORD']=ZOHO_CONFIG['ZOHO_PASSWORD']

end