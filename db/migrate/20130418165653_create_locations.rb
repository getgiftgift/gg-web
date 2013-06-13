class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.string :city
      t.string :state
      t.string :lat
      t.string :lng
      t.string :slug

      t.timestamps
    end
  end
end
