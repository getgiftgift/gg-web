Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook,
    ENV['FACEBOOK_APP_ID'],
    ENV['FACEBOOK_APP_SECRET'],
    scope: 'email,user_birthday,read_stream',
    token_params: { parse: :json }
     #, :display => 'popup'
end
