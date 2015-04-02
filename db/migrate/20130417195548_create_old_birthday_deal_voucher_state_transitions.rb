class CreateOldBirthdayDealVoucherStateTransitions < ActiveRecord::Migration
  def change
    create_table :birthday_deal_voucher_state_transitions do |t|
      t.integer :birthday_deal_voucher_id
      t.string :event
      t.string :from
      t.string :to
      t.datetime :created_at

      t.timestamps
    end
  end
end
