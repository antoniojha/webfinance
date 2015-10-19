RSpec.configure do |config|
  config.include(OmniauthMacros)
end

OmniAuth.config.test_mode = true