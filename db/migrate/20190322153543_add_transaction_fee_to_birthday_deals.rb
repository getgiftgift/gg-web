class AddTransactionFeeToBirthdayDeals < ActiveRecord::Migration
  def change
    add_monetize :birthday_deals, :transaction_fee, currency: { present: false }, amount: { default: 99 }
  end
end