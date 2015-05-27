class HomeController < ApplicationController
  layout 'application'

  def dashboard
    if current_user && current_user.admin?
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

      # BirthdayDealVoucher.where('verification_number like ?', ver).joins(:company).where('pin = ?', pin).first
    end
  end

end