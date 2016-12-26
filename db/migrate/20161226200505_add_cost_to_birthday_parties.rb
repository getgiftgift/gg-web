class AddCostToBirthdayParties < ActiveRecord::Migration
  def change
    add_monetize :birthday_parties, :cost, amount:{ default: 3000, null: false}
  end
end
