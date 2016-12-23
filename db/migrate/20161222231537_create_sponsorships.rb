class CreateSponsorships < ActiveRecord::Migration
  def change
    create_table :sponsorships do |t| 
      t.string    :name, null: false
      t.string    :note
      t.monetize  :amount_per_party, null: false
      t.datetime  :start_date, null: false
      t.datetime  :end_date, null: false
      t.monetize  :total_amount, null: false
    end
  end
end