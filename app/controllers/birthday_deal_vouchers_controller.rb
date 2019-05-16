class BirthdayDealVouchersController < ApplicationController
  # skip_before_filter :login_required
  # before_filter :customer_login_required, except: [:print]
  # before_filter :user_login_required, only: [:print]
  layout 'birthday'
  helper_method :birthday_deal_voucher, :party, :number_of_freebies_left, :company, :birthday_deal
  respond_to :js, :html
  
  def show
    @birthday_deal_voucher = current_user.birthday_party.birthday_deal_vouchers.includes(birthday_deal: [:restrictions], company: [:company_locations]).find(params[:id])
    @locations = company.company_locations
  rescue ActiveRecord::RecordNotFound
    redirect_to my_gifts_url unless @birthday_deal_voucher
  end

  def confirm
    @freebies = party.complimentary_redemptions
  end

  def verification
  end

  def redeem
    freebies = party.complimentary_redemptions
    if freebies > 0
      party.update(complimentary_redemptions: freebies-1)
    end
    birthday_deal_voucher.redeem!
    flash[:success] = t('.success')
    redirect_to [:verification, birthday_deal_voucher]     
  end

  def trash
    birthday_deal_voucher.trash
  end

  def keep
    birthday_deal_voucher.keep
  end

  private
    def birthday_deal_voucher
      @birthday_deal_voucher ||= BirthdayDealVoucher.find params[:id]
    end

    def party
      @party ||= birthday_deal_voucher.birthday_party
    end

    def company
      @company ||= birthday_deal_voucher.company
    end

    def birthday_deal
      @birthday_deal = @birthday_deal_voucher.birthday_deal
    end

    def number_of_freebies_left
      case party.complimentary_redemptions
      when 3
        "first"
      when 2
        "second"
      when 1
        "last"
      end
    end
end
