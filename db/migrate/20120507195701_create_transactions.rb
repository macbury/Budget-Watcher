class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer   :user_id
      t.string    :description
      t.string    :hash_uid
      t.integer   :amount_subunit
      t.integer   :account_id
      t.string    :amount_currency, :limit => 6, default: "PLN"
      t.integer   :transaction_type, :limit => 2
      t.datetime  :publish_date

      t.timestamps
    end

    add_index :transactions, :publish_date
    add_index :transactions, :user_id
    add_index :transactions, :hash_uid
    add_index :transactions, :account_id
    add_index :transactions, :transaction_type
    
  end
end
