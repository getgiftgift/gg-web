class CreateBirthdayDealsTable < ActiveRecord::Migration
  def up
    create_table :birthday_deals do |t|
      t.integer :company_id
      t.integer :value 
      t.string :hook 
      t.string :restrictions 
      t.string :how_to_redeem 
      t.string :slug 
      t.string :state 
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.date :start_date 
      t.date :end_date  
    end  
  end

  def down
    drop_table :birthday_deals
  end
end
