class CreateContact < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :first_name
      t.string :last_name
      t.string :postal_code
      t.string :email
      t.string :token
      t.references :company
      t.timestamps null: false
    end
  end
end
