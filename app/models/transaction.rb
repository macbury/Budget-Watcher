require "digest/md5"

class Transaction < ActiveRecord::Base
  include RecomendEngine
  Income          = 0
  Outcome         = 1
  Transfer        = 2

  belongs_to      :user
  belongs_to      :account
  belongs_to      :base_account,   class_name: "Account", foreign_key: "account_id"
  belongs_to      :base_account, class_name: "Account", foreign_key: "base_account_id"
  belongs_to      :category

  attr_accessible :amount, :description, :publish_date, :account_id, :base_account_id
  monetize        :amount_subunit, with_currency: :pln, :as => "amount"

  validates       :description, :amount, :publish_date, :account_id, presence:true
  validates       :description, length: { minimum: 3, maximum: 254 }

  validates       :account_id, :account => true

  before_save     :analyze_transaction
  after_save      :update_account_balance
  after_destroy   :remove_account_balance

  def analyze_transaction
    if base_account_id.present?
      self.transaction_type = Transaction::Transfer
    elsif self.amount > 0
      self.transaction_type = Transaction::Income
    else
      self.transaction_type = Transaction::Outcome
    end

    self.hash_uid           = Digest::MD5.hexdigest(self.description.strip)

    @update_account         = self.amount_subunit_changed? || self.account_id_changed? || self.base_account_id_changed?
    @last_account_id        = self.account_id_was
    @last_base_account_id   = self.base_account_id_was

    @last_amount            = Money.new(self.amount_subunit_was) if self.amount_subunit_was

    analyze_category
  end

  def update_account_balance
    return unless @update_account

    if transfer?
      last_amount_negative = @last_amount ? @last_amount*(-1) : nil
      update_account_balance_for(self.base_account, @last_base_account_id, self.amount*(-1), last_amount_negative)
    end

    update_account_balance_for(self.account, @last_account_id, self.amount, @last_amount)

    self.account.save
    @update_account  = false
    @last_account_id = nil
    @last_amount     = nil
  end
  
  def remove_account_balance
    self.account.balance -= self.amount
    self.account.save
  end

  def update_account_balance_for(current_account, last_account_id, current_amount, last_amount)
    Rails.logger.debug "Updating balance for account #{current_account.id} / #{last_account_id}"
    if last_account_id.nil? || last_account_id == current_account.id
      unless last_amount.nil?
        Rails.logger.debug "Account is the same and removing last amount: #{current_account.balance.to_s} - #{last_amount.to_s}"
        current_account.balance -= last_amount 
      end
    elsif !last_account_id.nil?
      last_account = Account.find(last_account_id)
      if last_amount
        Rails.logger.debug "Account chave changed substracting last amount from it: #{last_account.balance.to_s} - #{last_amount.to_s}"
        last_account.balance -= last_amount
      else
        Rails.logger.debug "Account chave changed substracting current amount from it: #{last_account.balance.to_s} - #{current_amount.to_s}"
        last_account.balance -= current_amount
      end
      last_account.save
    end
    Rails.logger.debug "Adding current amount to account: #{current_account.balance.to_s} + #{current_amount.to_s}"
    current_account.balance += current_amount
    current_account.save
  end

  def transfer?
    self.transaction_type == Transaction::Transfer
  end

  def income?
    self.transaction_type == Transaction::Income
  end

  def outcome?
    self.transaction_type == Transaction::Outcome
  end
end
