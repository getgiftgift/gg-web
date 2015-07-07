class ChangeCompanyUrlToWebsite < ActiveRecord::Migration
  def change
    change_table :companies do |t|
      t.rename :url, :website
    end
  end
end
