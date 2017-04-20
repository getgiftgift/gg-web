class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  # def facebook
  #   @user = User.from_omniauth(request.env["omniauth.auth"])

  #   if @user.persisted?
  #     save_referral_code_with_user(@user) if @user.sign_in_count == 0 && session[:referral_code]
  #     sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
  #     set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
  #   else
  #     session["devise.facebook_data"] = request.env["omniauth.auth"]
  #     redirect_to new_user_registration_url
  #   end
  # end
  #http://www.justinball.com/2014/02/27/omniauth-devise-and-facebook-client-login-dont-play-nice/
  def facebook
    @provider  = 'facebook'
    @oauth = Koala::Facebook::OAuth.new(ENV["FACEBOOK_APP_ID"], ENV["FACEBOOK_APP_SECRET"])
    token = params["token"]
    new_auth = @oauth.exchange_access_token_info(token)
    @graph = Koala::Facebook::API.new(new_auth["access_token"])
    auth = @graph.get_object("me")
    auth.merge!(new_auth.merge({provider: @provider}))
    @user = User.from_omniauth(auth)
    if @user.persisted?
      if @user.new_record?
        @user.save_referral_code(session[:referral_code])
        MailingList.add_to_list(@user)
      end
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to root_path
    end

  end
end