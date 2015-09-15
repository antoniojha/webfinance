CarrierWave.configure do |config|
  config.fog_credentials = {
    provider: "AWS",
    aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
    aws_secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]
  }
  config.fog_directory = ENV["S3_BUCKET_NAME"]
#  config.max_file_size= 5.megabytes # default value
#  config.validate_filename_format = true # default value

end