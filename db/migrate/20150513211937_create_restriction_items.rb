class CreateRestrictionItems < ActiveRecord::Migration
  def change
    create_table :restriction_items do |t|
      t.references :birthday_deal
      t.references :restriction
      t.timestamps null: false
    end
  end 
end
