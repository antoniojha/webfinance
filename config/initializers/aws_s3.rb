unless File.exists?("#{::Rails.root}/config/aws_s3.yml")
  S3_CONFIG = YAML.load_file("#{::Rails.root}/config/aws_s3.yml")[::Rails.env]
  ENV['S3_BUCKET_NAME']=S3_CONFIG['S3_BUCKET_NAME']
  ENV['AWS_ACCESS_KEY_ID']=S3_CONFIG['AWS_ACCESS_KEY_ID']
  ENV['AWS_SECRET_ACCESS_KEY']=S3_CONFIG['AWS_SECRET_ACCESS_KEY']
end