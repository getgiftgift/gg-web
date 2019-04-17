class Transaction < ActiveRecord::Base
	belongs_to :birthday_party
  belongs_to :voucher, class_name: 'BirthdayDealVoucher'

  monetize :amount_cents
end
