class AddStartDateAndEndDateToBirthdayParty < ActiveRecord::Migration
  def change
    rename_column :birthday_parties, :date, :start_date
    add_column :birthday_parties, :end_date, :date, null: false, index: true, default: (Date.today + BirthdayParty::PARTY_VALID_FOR)
  end
end
