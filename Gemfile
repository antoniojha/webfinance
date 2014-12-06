source 'https://rubygems.org'

ruby '2.1.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.5'

# yodlee gems
gem 'httparty'
gem 'hashie'

# This gem is used for rss feed parsing
gem 'pauldix-feedzirra'

# THis is used for ???
gem 'iconv'

# Paperclip, used to upload pictures to Amazon S3
gem 'paperclip'

gem 'paperclip-compression'
# This provides standardized interface to access a variety of spreadsheet format
gem 'roo'


gem 'aws-sdk'
gem 'cocaine'
ruby '2.1.1'
# use for pagination
gem 'will_paginate'
gem 'bootstrap-will_paginate'

gem 'faker'
gem 'figaro'

#scheduler
gem 'rufus-scheduler'

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
  gem 'capybara-webkit'
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

# Use jquery as the JavaScript library
gem 'jquery-rails'

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