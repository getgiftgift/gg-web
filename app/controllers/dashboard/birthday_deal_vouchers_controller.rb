class Dashboard::BirthdayDealVouchersController < ApplicationController

  def index
    @all_vouchers = BirthdayDealVoucher.all
    @deals = BirthdayDeal.all
    if params[:search]
      start_date = params[:search][:start_date]
      end_date = params[:search][:end_date]
      deal = params[:birthday_deal_id]
      state = params[:state]
      @vouchers = @deals.where("created_at >= ? AND created_at <= ? AND birthday_deal_id = ? AND state = ?", start_date, end_date, deal, state)
    end
  end






end