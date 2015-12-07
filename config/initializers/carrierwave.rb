FOG_CONFIG = YAML.load_file(Rails.root.join('config', 'fog.yml'))[Rails.env]

CarrierWave.configure do |config|
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: FOG_CONFIG['AWS_ACCESS_KEY_ID'],
    aws_secret_access_key: FOG_CONFIG['AWS_SECRET_ACCESS_KEY'],
    region: 'ap-southeast-1'
  }
  config.cache_dir = "#{Rails.root}/tmp/uploads"
  config.fog_directory = FOG_CONFIG['AWS_BUCKET']
end
