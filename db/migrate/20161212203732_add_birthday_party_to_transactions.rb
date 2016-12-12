class AddBirthdayPartyToTransactions < ActiveRecord::Migration
  def change
    add_reference :transactions, :birthday_party, index: true
    add_foreign_key :transactions, :birthday_parties
  end
end
