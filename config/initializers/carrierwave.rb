if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      provider:               'AWS',
      aws_access_key_id:      ENV['S3_KEY'],
      aws_secret_access_key:  ENV['S3_SECRET'],
      region:                 ENV['S3_REGION']
    }
    config.asset_host       = "//#{ENV['S3_BUCKET']}.s3.amazonaws.com"
    config.fog_directory  = ENV['S3_BUCKET']
    config.storage = :fog
  end
elsif Rails.env.development?
  CarrierWave.configure do |config|
    # config.storage = :file
    config.fog_credentials = {
      provider:               'AWS',
      aws_access_key_id:      ENV['S3_KEY'],
      aws_secret_access_key:  ENV['S3_SECRET'],
      region:                 ENV['S3_REGION']
    }
    config.asset_host       = "//#{ENV['S3_BUCKET']}.s3.amazonaws.com"
    config.fog_directory  = ENV['S3_BUCKET']
    config.storage = :fog
    config.enable_processing = true
  end
elsif Rails.env.test? or Rails.env.cucumber?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
end