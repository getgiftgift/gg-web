class AddFieldsToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :cc_last_four, :string
    add_column :contacts, :cc_card_type, :string
    add_column :contacts, :cc_expiration_month, :string
    add_column :contacts, :cc_expiration_year, :string
    add_column :contacts, :gateway_customer_id, :string
  end
end
