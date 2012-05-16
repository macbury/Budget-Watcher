class AddTargetAccountToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :base_account_id, :integer
  end
end
