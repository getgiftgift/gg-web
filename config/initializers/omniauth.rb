Rails.application.config.middleware.use OmniAuth::Builder do
  # provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'], :scope => 'email,user_birthday,read_stream', :display => 'popup'


  provider :facebook, "462905540438142", "17b1bc0c1a99a0f78e5f1ce8a8a26252", :scope => 'email,user_birthday,read_stream' #, :display => 'popup'


end
