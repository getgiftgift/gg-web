class AddLocationToBirthdayDeals < ActiveRecord::Migration
  def change
    add_column :birthday_deals, :location_id, :integer
  end
end
