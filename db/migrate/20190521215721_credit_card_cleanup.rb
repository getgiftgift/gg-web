class CreditCardCleanup < ActiveRecord::Migration
  def change
    add_column :credit_card_profiles, :last4, :string

    remove_column :users, :payment_token
  end
end
