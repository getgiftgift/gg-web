module UsersHelper
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def user_full_name
    "#{current_user.first_name} #{current_user.last_name}"
  end  

end
