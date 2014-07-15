# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :subscription do
    email "MyString"
    name "MyString"
    paymill_id "MyString"
  end
end
