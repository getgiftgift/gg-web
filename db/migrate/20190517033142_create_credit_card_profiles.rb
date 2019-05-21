class CreateCreditCardProfiles < ActiveRecord::Migration
  def change
    create_table :credit_card_profiles do |t|
      t.integer :user_id
      t.string :cardconnect_profileid
      t.string :expiry
      t.string :card_type
      t.timestamps
    end
  end
end
