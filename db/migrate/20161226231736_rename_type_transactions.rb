class RenameTypeTransactions < ActiveRecord::Migration
  def change
    rename_column :transactions, :type_id, :sponsor_id
    rename_column :transactions, :type_type, :type
  end
end
