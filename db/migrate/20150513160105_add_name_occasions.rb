class AddNameOccasions < ActiveRecord::Migration
  def change
    add_column :occasions, :name, :string
  end
end
