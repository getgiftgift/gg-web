class AddBirthdayDealVoucherToTransactions < ActiveRecord::Migration
  def change
    add_reference :transactions, :voucher
  end
end
