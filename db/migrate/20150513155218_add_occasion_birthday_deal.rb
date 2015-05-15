class AddOccasionBirthdayDeal < ActiveRecord::Migration
  def change
    add_reference :birthday_deals, :occasion, index: true, foreign_key: true
  end
end
