class Referral < ActiveRecord::Migration
  def change
    create_table :referrals do |t|
      t.integer :referrer_id
      t.integer :recipient_id
    end
  end
end
