if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      provider:               ENV['FOG_PROVIDER'],
      aws_access_key_id:      ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key:  ENV['AWS_SECRET_ACCESS_KEY'],
      region:                 ENV['S3_REGION']
    }

    config.asset_host       = "//#{ENV['S3_BUCKET']}.s3.amazonaws.com"
    config.fog_directory  = ENV['S3_BUCKET']
    config.storage = :fog

    # Heroku config
    config.cache_dir = "#{Rails.root}/tmp/uploads"
    config.fog_public = false
    config.fog_attributes = {'Cache-Control'=>'max-age=315576000'} 

  end
elsif Rails.env.development?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = true
  end
elsif Rails.env.test? or Rails.env.cucumber?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
end