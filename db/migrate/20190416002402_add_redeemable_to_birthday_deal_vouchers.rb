class AddRedeemableToBirthdayDealVouchers < ActiveRecord::Migration
  def change
    add_column :birthday_deal_vouchers, :redeemable, :boolean, default: false
  end
end
