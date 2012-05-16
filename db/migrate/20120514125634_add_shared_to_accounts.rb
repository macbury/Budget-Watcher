class AddSharedToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :shared, :boolean, default: false
  end
end
