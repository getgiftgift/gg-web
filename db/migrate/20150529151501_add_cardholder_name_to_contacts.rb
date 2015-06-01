class AddCardholderNameToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :cardholder_name, :string
  end
end
