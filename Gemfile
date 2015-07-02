source 'https://rubygems.org'


ruby '2.1.5'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.5'

gem "auto_complete"

gem 'remotipart', '~> 1.2'

# yodlee gems
gem 'httparty'
gem 'hashie'

gem 'geocoder'
gem 'google_timezone'

gem 'timezone'
gem 'nearest_time_zone'

gem 'facebox-rails'
#calendar
gem "watu_table_builder", :require => "table_builder"
# This gem is used for rss feed parsing
gem 'pauldix-feedzirra'
# gem for manipulating different currency
gem 'money'
# This is used for ???
gem 'iconv'
# used for twitter authentication
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'omniauth-identity'
gem 'omniauth-linkedin-oauth2'
# Paperclip, used to upload pictures to Amazon S3
gem 'paperclip'
gem 'aws-sdk'
gem 'rmagick'
gem 'paperclip-compression'
#Carrierwave, used to upload pictures to Amazon S3
gem 'carrierwave'
gem 'fog'
gem 'carrierwave_direct'
gem 'sidekiq'

# This provides standardized interface to access a variety of spreadsheet format
gem 'roo'

# this allows for flexible time entry
gem 'chronic'

gem 'cocaine'
gem 'posix-spawn' #install to free up memory http://adamniedzielski.github.io/blog/2014/02/05/fighting-paperclip-errno-enomem-error/
# use for pagination
gem 'will_paginate'
gem 'bootstrap-will_paginate'

gem 'faker'
gem 'figaro'

#scheduler
gem 'rufus-scheduler'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Gon allow javascript to access variable created in controller
gem 'gon'

# Install library to use Yellow Fade Technique to highlight ajax change
gem 'jquery-ui-rails'
#User ActiveModel has_secure_password
gem 'bcrypt-ruby', '3.1.2'

# Used for CSS
gem 'bootstrap-sass'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
group :development,:test do
  # shows error for asset-pipeline in production that is usually not shown in development
 # gem 'sprockets_better_errors'
  # Use rpsec-rails for development testing
  gem 'launchy'
  gem 'rconsole', '~> 0.1.0'
  gem 'sqlite3'
  gem 'rspec-rails'
  gem 'guard-rspec'
  gem 'database_cleaner'
  #Please add the following to your Gemfile to avoid polling for changes:
  require 'rbconfig'
  if RbConfig::CONFIG['target_os'] =~ /mswin|mingw|cygwin/i
    gem 'wdm', '>= 0.1.0'
  end

end
group :test do
  gem 'capybara'
#  gem 'capybara-webkit'
  gem 'spork', "> 0.9.0.rc"
  gem 'factory_girl_rails'
  gem 'selenium-webdriver'
    # the following gems will speed up rspec testing
  gem 'spork-rails'
  gem 'guard-spork'
  gem 'childprocess'
  gem "rack_session_access"
end


group :production do
  # refer to Michael Hurtl chapter 1.4.1 and 2
  gem 'pg'#PostgreSQL
  gem 'rails_12factor' #used by Heroku to serve static assets such as images and stylesheets.

  # a better webserver than WebBrick to handle big traffic
  gem 'unicorn'
end

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby


# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
gem 'jquery-turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

gem 'googlecharts'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]