FOG_CONFIG = Rails.configuration.x.fog

CarrierWave.configure do |config|
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: FOG_CONFIG['AWS_ACCESS_KEY_ID'],
    aws_secret_access_key: FOG_CONFIG['AWS_SECRET_ACCESS_KEY'],
    region: FOG_CONFIG['AWS_REGION']
  }
  config.cache_dir = "#{Rails.root}/tmp/uploads"
  config.fog_directory = FOG_CONFIG['AWS_BUCKET']
end
