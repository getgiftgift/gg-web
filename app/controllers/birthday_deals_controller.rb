class BirthdayDealsController < ApplicationController

  skip_filter :verify_login_and_birthday, only: [:add_birthday_to_user, :add_location_to_user]

  layout 'birthday'

  respond_to :html, :json

  def my_gifts
    if current_user.is_testuser?
      @birthday_vouchers = current_user.birthday_party.birthday_deal_vouchers.with_state(:kept, :redeemed).order(:state)
    else
      @birthday_vouchers = current_user.birthday_party.birthday_deal_vouchers.with_state(:kept, :redeemed).order(:state)
    end
  end

  def index
    if customer_logged_in?
      @party = current_user.birthday_party
      @birthday_deal_vouchers = @party.birthday_deal_vouchers.is_available.with_state(:wrapped).includes(:birthday_deal => :company)
      if current_user.is_testuser?
        if @birthday_deal_vouchers.empty?
          @party.birthday_deal_vouchers.is_available.update_all({state: 'wrapped'})
        end
        @birthday_deal_vouchers = @party.birthday_deal_vouchers.is_available.with_state(:wrapped).includes(:birthday_deal => :company)
        return render action: 'index_view_birthday_deals'
      end

      if @party.activated? && @party.available?
        @party.create_vouchers if @party.birthday_deal_vouchers.blank?
        @birthday_deal_vouchers = @party.reload.birthday_deal_vouchers
      else
        return render 'index_not_your_birthday'
      end
      if @birthday_deal_vouchers.empty?
        @deals = BirthdayDeal.in_location(current_location).is_active
        return render 'index_not_your_birthday' if @deals.empty?
      end

      render action: 'index_view_birthday_deals'
    end
  end

  def show
    @birthday_deal = BirthdayDeal.find(params[:id])
  end

  protected

end
