CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider => 'AWS',
    :aws_access_key_id => Settings.aws_access_key_id,
    :aws_secret_access_key => Settings.aws_secret_access_key,
    :region => Settings.aws_region,
  }
  config.fog_directory = Settings.fog_directory
  config.fog_public     = true
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}

  config.storage = Settings.carrierwave_storage.to_sym
end
