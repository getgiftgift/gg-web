class BirthdayDealsController < ApplicationController

  skip_filter :verify_login_and_birthday, only: [:add_birthday_to_user, :add_location_to_user]

  layout 'birthday'

  respond_to :html, :json

  def my_gifts
    if current_user.is_testuser?
      @birthday_vouchers = current_user.birthday_deal_vouchers.in_location(current_location).with_state(:kept, :redeemed).order(:state)
    else
      @birthday_vouchers = current_user.birthday_deal_vouchers.is_available.in_location(current_location).with_state(:kept, :redeemed).order(:state)
    end
  end

  def index
    if customer_logged_in?
      @location = current_location
      @party = current_user.birthday_party
      @birthday_deal_vouchers = @party.birthday_deal_vouchers
      if @birthday_deal_vouchers.empty?
        @deals = BirthdayDeal.in_location(current_location).is_active
        return render 'index_not_your_birthday' if @deals.empty?
      end
      @birthday_deal_vouchers = current_user.birthday_deal_vouchers.is_available.with_state(:wrapped).includes(:birthday_deal => :company)
      if current_user.is_testuser? && @birthday_deal_vouchers.empty?
        @party.birthday_deal_vouchers.is_available.update_all({state: 'wrapped'})
        @birthday_deal_vouchers = @party.birthday_deal_vouchers.is_available.with_state(:wrapped).includes(:birthday_deal => :company)
      end
      render action: 'index_view_birthday_deals'
    end
  end

  def show
    @birthday_deal = BirthdayDeal.find(params[:id])
  end

  protected

end
