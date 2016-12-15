class AddDateToBirthdayParty < ActiveRecord::Migration
  def change
    add_column :birthday_parties, :date, :date

    add_index :birthday_parties, [:user_id, :date], unique: true
  end
end