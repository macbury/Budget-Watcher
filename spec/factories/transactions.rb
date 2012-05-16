# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :transaction do
    user
    account
    description "Simple transaction"
    amount_subunit 100
    publish_date Time.now
  end
end
