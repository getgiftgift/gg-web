class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_filter :set_referral_code
  before_filter :verify_login_and_birthday, unless: :devise_controller?

  helper_method :current_location

  layout 'birthday'

  def after_sign_in_path_for(resource)
    ## Disable BirthdayParty for now, just give out the deals
    # resource.admin? ? dashboard_index_path : birthday_parties_path
    resource.admin? ? dashboard_index_path : birthday_deals_path
  end

  def admin_login_required
    unless current_user && current_user.admin?
      redirect_to root_url
    end
  end

  def customer_required
    unless current_user
      redirect_to root_url
    end
  end

  def customer_logged_in?
    !!current_user
  end

  def logged_in?
    !!current_user && current_user.admin?
  end

  def location_from_session
      @current_location = Location.find(session[:location_id]) if session[:location_id]
  end

  def location_from_params
    if params[:geolocation]
      @current_location = Location.find_by_slug(params[:geolocation])
    end
    @current_location
  end

  def default_location
    # Location.find_by_slug('como')
    Location.first
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
    # @current_location ||= (location_from_params || location_from_session || location_from_ip || default_location)
    @current_location  ||= (current_user.location ||  default_location)
  end

  def set_referral_code
    session[:referral_code] = params[:r] if params[:r]
  end

  def save_referral_code_with_user(user)
    referrer = User.where(referral_code: session[:referral_code]).first
    Referral.create(recipient: user, referrer: referrer) if referrer && referrer != user
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation, :first_name, :last_name, :birthdate, :"birthdate(1i)", :"birthdate(2i)", :"birthdate(3i)" ) }
  end


  def verify_login_and_birthday
    if customer_logged_in?
      return render 'home/customer_enter_birthday' if current_user.birthdate.blank?
      return render 'home/customer_enter_location' if current_user.location.blank?
    else
      session[:return_to] = root_path
      @user = User.new
      return render 'home/customer_login'
    end
  end
end
