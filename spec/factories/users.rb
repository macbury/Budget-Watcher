# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence :email do |n|
    "email#{n}@test.com"
  end

  factory :user do
    email
    password "foobar1"
    password_confirmation "foobar1"
  end
end
