class HomeController < ApplicationController
  layout 'application'

  def dashboard
    if current_user && current_user.is_admin?
      redirect_to dashboard_index_path
    else
      redirect_to new_user_session_path
    end
  end
  
  def terms
  end

  def privacy
  end

  def redeem
    if params[:redeem]
      @pin = params[:redeem][:pin]
      ver = params[:redeem][:verification]
      @deal = BirthdayDealVoucher.where('verification_number like ?', "%#{ver}").joins(:company).where('pin = ?', @pin).last
      redirect_to redeem_path
    else
      render 'redeem'
    end
  end

end