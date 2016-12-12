class AddUserToBirthdayParty < ActiveRecord::Migration
  def change
    add_reference :birthday_parties, :user, index: true, foreign_key: true
  end
end
