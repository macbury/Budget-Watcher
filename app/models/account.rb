class Account < ActiveRecord::Base
  belongs_to      :user
  has_many        :transactions, :dependent => :destroy

  attr_accessible :balance_currency, :balance_subunit, :name, :shared

  validates       :balance, :name, presence: true
  validates       :name, length: { minimum: 3, maximum: 32 }, uniqueness: { scope: :user_id }
  monetize        :balance_subunit, with_currency: :pln, :as => "balance"
end
