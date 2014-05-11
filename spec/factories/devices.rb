# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :device do
    name "MyString"
    emei "MyString"
    cost_price 1.5
  end
end
