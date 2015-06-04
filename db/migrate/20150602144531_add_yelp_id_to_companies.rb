class AddYelpIdToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :yelp_id, :string
  end
end
