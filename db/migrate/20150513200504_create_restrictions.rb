class CreateRestrictions < ActiveRecord::Migration
  def change
    create_table :restrictions do |t|
      t.string :category
      t.string :phrase
      t.string :amount
      t.timestamps null: false
    end
  end
end



