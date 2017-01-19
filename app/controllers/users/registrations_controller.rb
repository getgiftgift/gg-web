class Users::RegistrationsController < Devise::RegistrationsController

  layout 'birthday'

  def show
    @subscription = current_user.subscription
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
