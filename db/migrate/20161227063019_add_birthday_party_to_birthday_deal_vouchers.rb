class AddBirthdayPartyToBirthdayDealVouchers < ActiveRecord::Migration
  def change
    add_reference :birthday_deal_vouchers, :birthday_party, index: true, foreign_key: true, null: false
    remove_reference :birthday_deal_vouchers, :user, index: true
  end
end
