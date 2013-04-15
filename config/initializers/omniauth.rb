Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, Settings.twitter_consumer_key, Settings.twitter_consumer_secret
end
