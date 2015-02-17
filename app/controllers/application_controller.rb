class ApplicationController < ActionController::Base
  protect_from_forgery
  
  # Unpermitted parameters: first_name, last_name, birthdate(2i), birthdate(3i), birthdate(1i)
  before_action :configure_permitted_parameters, if: :devise_controller?


  def admin_login_required
    unless current_user && current_user.admin?
      flash[:error] = "You are not an admin."
      redirect_to root_url  
    end  
  end

  def customer_logged_in?
    !!current_user && !current_user.admin?
  end

  def logged_in?
    !!current_user && current_user.admin?
  end 

  def location_from_session
      @current_location = Location.find(session[:location_id]) if session[:location_id]
    end

  def location_from_params
    if (params and params[:geolocation] and (params[:geolocation] == 'columbia-mo' || params[:geolocation] == 'jefferson-city-mo'))
      @current_location = Location.find_by_slug(params[:geolocation])
    end
    @current_location
  end

  def default_location
    Location.find_by_slug('jefferson-city-mo')
  end

  def location_from_ip
    ip_lookup = params[:simulated_ip] unless Rails.env.production?
    ip_lookup ||= request.remote_ip
    c = GeoIP.new('GeoLiteCity.dat').city(ip_lookup)
    return nil if c.nil?
    closest_city = Location.closest(origin: [c.latitude, c.longitude]).first
    session[:location_id] = closest_city.id
    @current_location = closest_city
  end

  def current_location
      @current_location ||= (location_from_params || location_from_session || location_from_ip || default_location)
  end


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation, :first_name, :last_name, :birthdate, :"birthdate(1i)", :"birthdate(2i)", :"birthdate(3i)" ) }
  end
end
