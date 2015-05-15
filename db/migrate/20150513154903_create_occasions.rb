class CreateOccasions < ActiveRecord::Migration
  def change
    create_table :occasions do |t|

      t.timestamps null: false
    end
  end
end
