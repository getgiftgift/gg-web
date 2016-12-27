class ChangeTransactionsColumnsNull < ActiveRecord::Migration
  def change
    change_column_null :transactions, :transaction_id, true
    change_column_null :transactions, :processor, true
  end
end
