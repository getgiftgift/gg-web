class Dashboard::BirthdayDealVouchersController < ApplicationController
  before_filter :admin_login_required

  layout 'dashboard'

  def index
    # byebug
    today = Date.today
    @market =  Location.find params[:location_id]

    params[:search].nil? ? @start_date = (today - 1.month).beginning_of_month.at_midnight : @start_date = params[:search][:start_date].to_date.at_midnight
    params[:search].nil? ? @end_date = (today - 1.month).end_of_month.end_of_day : @end_date = params[:search][:end_date].to_date.end_of_day
    @price = Money.new('25')
    @deals = BirthdayDeal.in_location(@market).includes(:company, :birthday_deal_vouchers).where('birthday_deal_vouchers.created_at>=? AND birthday_deal_vouchers.created_at<=?', @start_date, @end_date).references(:birthday_deal_vouchers)
    @vouchers_count_total = 0
    @locations_count_total = 0
    @money_total = 0
  end

end