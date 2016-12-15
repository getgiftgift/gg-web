class AddNullChecks < ActiveRecord::Migration
  def change
    change_column :birthday_parties, :date, :date, null: false
    change_column :birthday_parties, :user_id, :integer, null: false
  end
end
