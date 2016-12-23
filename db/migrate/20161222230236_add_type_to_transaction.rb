class AddTypeToTransaction < ActiveRecord::Migration
  def change
    add_reference :transactions, :type, index: true, polymorphic: true
  end
end
