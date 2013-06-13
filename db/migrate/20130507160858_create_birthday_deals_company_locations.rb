class CreateBirthdayDealsCompanyLocations < ActiveRecord::Migration
  def change
    create_table :birthday_deals_company_locations, id: false do |t|
      t.references :birthday_deal
      t.references :company_location

      t.timestamps
    end
    add_index :birthday_deals_company_locations, :birthday_deal_id
    add_index :birthday_deals_company_locations, :company_location_id
  end
end