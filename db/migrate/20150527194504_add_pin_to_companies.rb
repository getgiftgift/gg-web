class AddPinToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :pin, :string
  end
end
