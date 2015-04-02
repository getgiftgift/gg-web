class CreateBirthdayDealVoucherStateTransitions < ActiveRecord::Migration
  def change
    create_table :birthday_deal_voucher_state_transitions do |t|
      t.references :birthday_deal_voucher, index: true
      t.string :namespace
      t.string :event
      t.string :from
      t.string :to
      t.timestamp :created_at
    end
    add_foreign_key :birthday_deal_voucher_state_transitions, :birthday_deal_vouchers
  end
end
