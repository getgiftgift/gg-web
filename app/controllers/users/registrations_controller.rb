class Users::RegistrationsController < Devise::RegistrationsController

  layout 'birthday'

  def show
    @subscription_status = MailingList.subscription_status(current_user)
  end

  def subscribe
    MailingList.subscribe(current_user)
    redirect_to my_account_path
  end

  def unsubscribe
    MailingList.unsubscribe(current_user)
    redirect_to my_account_path
  end

  def update_birthday
    if current_user.birthdate.blank? and user_params.include?(:birthdate)
      current_user.birthdate = user_params[:birthdate]
    end
    current_user.save
    redirect_to root_url
  end

  def update_location
    if user_params.include?(:location)
      location = Location.find(user_params[:location])
      current_user.location = location
    end
    current_user.save
    redirect_to root_url
  end

  protected
  def user_params
    @user_params = params.require(:user).permit(:location, :birthdate)
  end

end
