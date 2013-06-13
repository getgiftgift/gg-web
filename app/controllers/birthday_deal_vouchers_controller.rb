class BirthdayDealVouchersController < ApplicationController
  # skip_before_filter :login_required
  # before_filter :customer_login_required, except: [:print]
  # before_filter :user_login_required, only: [:print]
  
  respond_to :js, :html
  def trash
    @birthday_deal_voucher = current_user.birthday_deal_vouchers.find params[:id]
    @birthday_deal_voucher.trash
  end

  def keep
    @birthday_deal_voucher = current_user.birthday_deal_vouchers.find params[:id]
    @birthday_deal_voucher.keep
  end

  def print
    if logged_in?
      @birthday_deal_voucher = BirthdayDealVoucher.find(params[:id])
    else
      begin
        @birthday_deal_voucher = current_user.birthday_deal_vouchers.find params[:id]
      rescue ActiveRecord::RecordNotFound
        flash[:notice] = "There was a problem retrieving the voucher"
        return redirect_to account_path
      end
    end

    if logged_in? || @birthday_deal_voucher.try(:print_voucher)
      output = DownloadBirthdayVoucher.new.to_pdf(@birthday_deal_voucher)
      send_data output, :filename => "birthday_deal_#{@birthday_deal_voucher.dashed_verification_number}.pdf",
                        :type => "application/pdf"
    else
      flash[:notice] = "There was a problem retrieving the voucher"
      redirect_to account_path
    end

  end
end
