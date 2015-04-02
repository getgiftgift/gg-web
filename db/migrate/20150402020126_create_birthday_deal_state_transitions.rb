class CreateBirthdayDealStateTransitions < ActiveRecord::Migration
  def change
    create_table :birthday_deal_state_transitions do |t|
      t.references :birthday_deal, index: true
      t.string :namespace
      t.string :event
      t.string :from
      t.string :to
      t.timestamp :created_at
    end
    add_foreign_key :birthday_deal_state_transitions, :birthday_deals
  end
end
