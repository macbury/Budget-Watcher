class AccountValidator < ActiveModel::Validator
  # implement the method called during validation
  def validate(record)
    record.errors[:account_id] << I18n.t('errors.messages.account_transfer') if record.base_account_id && record.account_id == record.base_account_id
  end
end