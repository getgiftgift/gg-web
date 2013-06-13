class AddLocationToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :location_id, :integer
  end
end
