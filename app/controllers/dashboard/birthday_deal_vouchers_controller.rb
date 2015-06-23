class Dashboard::BirthdayDealVouchersController < ApplicationController
  before_filter :admin_login_required

  layout 'dashboard'

  def index
    today = Date.today
    @start_date = (today - 1.month).beginning_of_month 
    @end_date = (today - 1.month).end_of_month
    @price = Money.new('25')
    @deals = BirthdayDeal.includes(:company, :birthday_deal_vouchers).where('birthday_deal_vouchers.created_at>=? AND birthday_deal_vouchers.created_at<=?', @start_date, @end_date).references(:birthday_deal_vouchers)
  end


end