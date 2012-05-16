class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.integer :user_id
      t.string :name
      t.integer :balance_subunit, default: 0
      t.string :balance_currency, default: "PLN"

      t.timestamps
    end

    add_index :accounts, :user_id
  end
end
