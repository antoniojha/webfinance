$redis = Redis.new(:host => ENV['REDIS_CLOUD_HOST'], :port => ENV['REDIS_CLOUD_PORT'], :password => ENV['REDIS_CLOUD_PASSWORD'])
