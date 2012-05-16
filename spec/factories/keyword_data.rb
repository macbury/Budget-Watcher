# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :keyword_datum, :class => 'KeywordData' do
    word "MyString"
    category_id 1
    sum 1
  end
end
