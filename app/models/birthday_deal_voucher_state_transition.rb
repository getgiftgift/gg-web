class BirthdayDealVoucherStateTransition < ActiveRecord::Base
  belongs_to :birthday_deal_voucher
  attr_accessible :created_at, :event, :from, :to, :birthday_deal_voucher_id
end
