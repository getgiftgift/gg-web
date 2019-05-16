class AddComplimentaryRedemptionsToBirthdayParty < ActiveRecord::Migration
  def change
    add_column :birthday_parties, :complimentary_redemptions, :integer, default: 3
  end
end
