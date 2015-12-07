CarrierWave.configure do |config|
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: 'AKIAILD7RSL6EKZH56EA',
    aws_secret_access_key: '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',
    region: 'ap-southeast-1'
  }
  config.cache_dir = "#{Rails.root}/tmp/uploads"
  config.fog_directory = Rails.env.production? ? 'guangho-file' : 'guangho-test'
end
