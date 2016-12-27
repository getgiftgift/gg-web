class RenameColumnSponsorIdToSponsorshipIdOnTransactions < ActiveRecord::Migration
  def change
    rename_column :transactions, :sponsor_id, :sponsorship_id
  end
end
