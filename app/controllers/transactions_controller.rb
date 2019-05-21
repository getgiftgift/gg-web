# frozen_string_literal: true

class TransactionsController < ApplicationController
  skip_filter :verify_login_and_birthday

  helper_method :voucher, :party, :saved_user_payment_token

  def new
    @credit_card_profile = current_user.last_unexpired_credit_card_profile
    if @credit_card_profile.nil?
      redirect_to([:new_payment_method, voucher]) && return
    end
    @transaction = Transaction.new
  end

  def create
    if params[:payment] == 'new'
      redirect_to([:new_payment_method, voucher]) && return
    end

    cch = CardConnectHelper.new(current_user, voucher)

    if params[:credit_card_profile_id]
      ccp = current_user.credit_card_profiles.find(params[:credit_card_profile_id])
      result = cch.charge_with_profile(ccp, params)
    else
      result = cch.charge_without_profile(params)
    end

    if result[:result]
      flash[:success] = t('.success')
      voucher.redeem!
      redirect_to [:verification, voucher]
    else
      flash[:error] = result[:error]
      render :new_payment_method
    end
  end

  def new_payment_method
  end

  def admin_bypass
    return redirect_to(root_path) unless current_user.is_admin?
    voucher.make_redeemable!
    redirect_to voucher
  end

  private

  def voucher
    @voucher ||= BirthdayDealVoucher.find params[:id]
  end

  def party
    @party ||= voucher.birthday_party
  end
end
