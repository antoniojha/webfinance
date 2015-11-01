unless File.exists?("#{::Rails.root}/config/google.yml")
  GOOGLE_CONFIG = YAML.load_file("#{::Rails.root}/config/google.yml")[::Rails.env]
  ENV['GOOGLE_KEY']=GOOGLE_CONFIG['KEY'].to_s
  ENV['GOOGLE_SECRET']=GOOGLE_CONFIG['SECRET'].to_s
end