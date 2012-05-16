# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence :name do |n|
    "Account #{n}"
  end
  factory :account do
    user
    name
    balance_subunit 0
  end
end
