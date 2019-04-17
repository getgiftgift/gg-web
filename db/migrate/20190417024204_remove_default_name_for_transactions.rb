class RemoveDefaultNameForTransactions < ActiveRecord::Migration
  def change
    change_column_default :transactions, :name, nil
  end
end
