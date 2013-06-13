class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :phone
      t.string :street1
      t.string :street2
      t.string :city
      t.string :state
      t.string :postal_code
      t.boolean :archived
      t.string :url
      t.string :image

      t.timestamps
    end
  end
end
