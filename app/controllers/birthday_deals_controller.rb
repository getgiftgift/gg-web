class BirthdayDealsController < ApplicationController
  
  before_filter :verify_login_and_birthday, except: [:add_birthday_to_user]

  layout 'birthday'

  respond_to :html, :json

  def account
    @user = current_user
    @birthday_vouchers = @user.birthday_deal_vouchers.with_state(:kept)
  end

  def index
    if customer_logged_in?
      @birthday_deal_vouchers = current_user.birthday_deal_vouchers.is_available
      # @birthday_deal_vouchers = current_user.birthday_deal_vouchers.is_available.in_location(current_location)
      if @birthday_deal_vouchers.empty?
        @deals = BirthdayDeal.is_active
        # @deals = BirthdayDeal.in_location(current_location).is_active
        return render 'index_not_your_birthday' if @deals.empty?
        @birthday_deal_vouchers = @deals.each.collect{|bd| bd.create_voucher_for(current_user)}
      end
      @birthday_deal_vouchers = current_user.birthday_deal_vouchers.is_available.with_state(:wrapped).includes(:birthday_deal => :company)  
      if current_user.test_user? && @birthday_deal_vouchers.empty?
        current_user.birthday_deal_vouchers.is_available.update_all({state: 'wrapped'})
        @birthday_deal_vouchers = current_user.birthday_deal_vouchers.is_available.with_state(:wrapped).includes(:birthday_deal => :company)  
      end
      render action: 'index_view_birthday_deals'
    else
      @customer = Customer.new
      render action: 'index_customer_login'
    end
  end

  def show
    @birthday_deal = BirthdayDeal.find(params[:id])
  end

  def add_birthday_to_user
    @customer = current_user
    begin
      @customer.update_attributes( birthdate: Date.new(params[:user_birthdate]['birthdate(1i)'].to_i, params[:user_birthdate]['birthdate(2i)'].to_i, params[:user_birthdate]['birthdate(3i)'].to_i))
      @customer.save!
    rescue
    end
    redirect_to birthday_deals_url
  end

  protected

  def verify_login_and_birthday
    return redirect_to dashboard_path if current_user and current_user.admin?
    if customer_logged_in?
      birthday = current_user.adjusted_birthday
      return render 'customer_enter_birthday' if birthday.nil?
      unless current_user.eligible_for_birthday_deals?
        return render 'index_not_your_birthday'
      end
    else
      session[:return_to] = birthday_deals_path
      return render 'index_customer_login'
    end
  end
end
