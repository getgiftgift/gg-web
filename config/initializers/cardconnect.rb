CardConnect.configure do |config|
  config.merchant_id  = ENV['CARDCONNECT_MERCHANT_ID']
  config.api_username = ENV['CARDCONNECT_API_USERNAME']
  config.api_password = ENV['CARDCONNECT_API_PASSWORD']
  config.endpoint     = ENV['CARDCONNECT_API_ENDPOINT']
end