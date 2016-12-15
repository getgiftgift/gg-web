class AddColumnsToTransactions < ActiveRecord::Migration
  def change
    remove_column :transactions, :first_name, :string
    remove_column :transactions, :last_name, :string
    remove_column :transactions, :amount, :string

    change_table :transactions do |t|
      t.string      :transaction_id, null: false
      t.timestamp   :settled_at
      t.string      :processor, null: false
      t.monetize    :amount, null: false
      t.string      :name, default: 'Anonymous'
      t.string      :note
    end
  end
end
