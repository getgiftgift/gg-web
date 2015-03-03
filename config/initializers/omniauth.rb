Rails.application.config.middleware.use OmniAuth::Builder do
  
  if Rails.env.production?
    provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET'], :scope => 'email,user_birthday,read_stream' #, :display => 'popup'
  else
    provider :facebook, '462905540438142', '17b1bc0c1a99a0f78e5f1ce8a8a26252', :scope => 'email,user_birthday,read_stream' #, :display => 'popup'
  end

end
