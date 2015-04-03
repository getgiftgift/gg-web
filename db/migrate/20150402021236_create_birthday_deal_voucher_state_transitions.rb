class CreateBirthdayDealVoucherStateTransitions < ActiveRecord::Migration
  def change
    create_table :birthday_deal_voucher_state_transitions do |t|
      t.references :birthday_deal_voucher
      t.string :namespace
      t.string :event
      t.string :from
      t.string :to
      t.timestamp :created_at
    end
    add_foreign_key :birthday_deal_voucher_state_transitions, :birthday_deal_vouchers
    add_index :birthday_deal_voucher_state_transitions, :birthday_deal_voucher_id, name: 'index_transitions_on_voucher_id'
  end
end
