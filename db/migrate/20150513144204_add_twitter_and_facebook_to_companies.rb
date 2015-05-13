class AddTwitterAndFacebookToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :facebook_handle, :string
    add_column :companies, :twitter_handle, :string
  end
end
