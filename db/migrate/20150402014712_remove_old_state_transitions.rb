class RemoveOldStateTransitions < ActiveRecord::Migration
  def up
    drop_table :birthday_deal_state_transitions
    drop_table :birthday_deal_voucher_state_transitions
  end


  def down
    create_table :birthday_deal_state_transitions do |t|
      t.integer :birthday_deal_id
      t.string :event
      t.string :from
      t.string :to
      t.datetime :created_at

      t.timestamps
    end

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
