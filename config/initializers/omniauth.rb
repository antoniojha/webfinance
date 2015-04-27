Rails.application.config.middleware.use OmniAuth::Builder do
  # provider :developer unless Rails.env.production?
  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
  provider :google_oauth2, ENV['GOOGLE_KEY'], ENV['GOOGLE_SECRET']
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET']
  provider :identity, on_failed_registration: lambda { |env|
    IdentitiesController.action(:new).call(env)
  }
end