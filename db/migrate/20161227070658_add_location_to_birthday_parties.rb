class AddLocationToBirthdayParties < ActiveRecord::Migration
  def change
    add_reference :birthday_parties, :location, index: true, foreign_key: true

    reversible do |dir|
      dir.up do
        BirthdayParty.includes(:user).all.each do |party|
          party.update_attribute(:location, party.user.location)
        end
      end
    end
  end
end
