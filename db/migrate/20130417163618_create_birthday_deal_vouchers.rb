class CreateBirthdayDealVouchers < ActiveRecord::Migration
  def change
    create_table :birthday_deal_vouchers do |t|
      t.integer :birthday_deal_id
      t.integer :user_id
      t.string :verification_number
      t.date :valid_on
      t.date :good_through
      t.string :state

      t.timestamps
    end
  end
end
