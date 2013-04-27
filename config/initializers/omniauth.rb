Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, Settings.twitter_consumer_key, Settings.twitter_consumer_secret
  provider :facebook, Settings.facebook_consumer_key, Settings.facebook_consumer_secret
end
