class CreateBirthdayParties < ActiveRecord::Migration
  def change
    create_table :birthday_parties do |t|

      t.timestamps null: false
    end
  end
end
