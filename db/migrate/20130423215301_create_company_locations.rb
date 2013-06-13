class CreateCompanyLocations < ActiveRecord::Migration
  def change
    create_table :company_locations do |t|
      t.string :name
      t.string :phone
      t.string :fax
      t.string :street1
      t.string :street2
      t.string :city
      t.string :state
      t.string :postal_code
      t.column :company_id, :integer
      t.column :location_id, :integer

      t.timestamps
    end
  end
end