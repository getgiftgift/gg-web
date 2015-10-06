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

  def verify
    if params[:verify]
      @pin = params[:verify][:pin]
      @ver = params[:verify][:verification]
      @deal = BirthdayDealVoucher.where('verification_number like ?', "%#{@ver}").joins(:company).where('pin = ?', @pin).last
    end
  end

end