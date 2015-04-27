require 'securerandom'
Webfinance::Application.config.secret_key_base = if Rails.env.development? or Rails.env.test?
  SecureRandom.hex(64)
else
  ENV['SECRET_TOKEN']
end