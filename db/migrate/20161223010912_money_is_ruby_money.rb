class MoneyIsRubyMoney < ActiveRecord::Migration
  def change
    remove_column :birthday_deals, :value
    add_monetize :birthday_deals, :value
  end
end
